# frozen_string_literal: true

module FilmData
  # = Data Load Service
  #
  # Class DataLoadService processes an instance of FilmLocationsInSanFrancisco to build out the
  # related models.
  class DataLoadService
    def initialize
      @person_cache = Hash.new { |h, name| h[name] = Person.find_or_initialize_by(name:) }
    end

    def process_film_data(data)
      film = Film.find_or_initialize_by(name: data.title, release_year: data.release_year)
      build_location(film, data) if data.location.present?

      if film.new_record?
        build_companies(film, data)
        build_directors(film, data)
        build_actors(film, data)
        build_writers(film, data)
      end

      film.save!
    end

    private

    def build_location(film, data)
      Location.find_or_initialize_by(name: data.location) do |location|
        film.film_locations.build(location:)

        if location.new_record?
          location.assign_attributes(find_neighborhood_id: data.find_neighborhood_id,
                                     analysis_neighborhood_id: data.analysis_neighborhood_id,
                                     supervisor_district_id: data.supervisor_district_id)
        end
      end
    end

    def build_companies(film, data)
      film.production_company = Company.find_or_initialize_by(name: data.production_company)
      film.distributor = Company.find_or_initialize_by(name: data.distributor) if data.distributor.present?
    end

    def build_directors(film, data)
      data.directors.each do |director|
        person = @person_cache[director]
        film.directing_credits.build(person:)
        person.roles.build(role: :director) unless person.director?
      end
    end

    def build_writers(film, data)
      data.writers.each do |writer|
        person = @person_cache[writer]
        film.writing_credits.build(person:)
        person.roles.build(role: :writer) unless person.writer?
      end
    end

    def build_actors(film, data)
      data.actors.each do |actor|
        person = @person_cache[actor]
        film.acting_credits.build(person:)
        person.roles.build(role: :actor) unless person.actor?
      end
    end
  end
end
