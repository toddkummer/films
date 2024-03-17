# frozen_string_literal: true

require_relative '../film_data/film_data'

namespace :film_data do
  desc 'Reload film data from CSV'
  task reload: %i[clear load]

  desc 'Load film data from CSV'
  task load: :environment do
    service = FilmData::DataLoadService.new
    FilmData::FilmLocationsInSanFrancisco.all.each_with_index do |data, index|
      service.process_film_data(data)
      putc '.' if (index % 10).zero?
    end
    puts "\nLoaded #{Film.count} films with \
          #{Location.count} locations and \
          #{Person.count} people \
          (#{PersonRole.director.count} directors, \
          #{PersonRole.actor.count} actors, \
          #{PersonRole.writer.count} writers)"
  end

  desc 'Clear film data from database'
  task clear: :environment do
    puts 'clearing out all data'
    Film.destroy_all
    Location.destroy_all
    Person.destroy_all
  end
end
