# frozen_string_literal: true

require_relative '../film_data/film_data'

namespace :film_data do
  desc 'Reload film data from CSV'
  task reload: %i[clear load]

  desc 'Load film data from CSV'
  task load: :environment do
    FilmData::FilmLocationsInSanFrancisco.all.each_with_index do |data, index|
      film = Film.find_or_initialize_by(name: data.title, release_year: data.release_year)
      if data.location.present?
        location = Location.find_or_initialize_by(name: data.location)
        film.film_locations.build(location:)
        if location.new_record?
          location.assign_attributes(find_neighborhood_id: data.find_neighborhood_id,
                                     analysis_neighborhood_id: data.analysis_neighborhood_id,
                                     supervisor_district_id: data.supervisor_district_id)
        end
      end

      if film.new_record?
        film.production_company = Company.find_or_initialize_by(name: data.production_company)
        film.distributor = Company.find_or_initialize_by(name: data.distributor) if data.distributor.present?
        data.directors.each do |director|
          film.directing_credits.build(person: Person.find_or_initialize_by(name: director))
        end
        data.writers.each do |writer|
          film.writing_credits.build(person: Person.find_or_initialize_by(name: writer))
        end
        data.actors.each do |actor|
          film.acting_credits.build(person: Person.find_or_initialize_by(name: actor))
        end
      end
      film.save!
      putc '.' if (index % 10).zero?
    end
    puts "\nLoaded #{Film.count} films with #{Location.count} locations"
  end

  desc 'Clear film data from database'
  task clear: :environment do
    puts 'clearing out all data'
    Film.destroy_all
    Location.destroy_all
    Person.destroy_all
  end
end
