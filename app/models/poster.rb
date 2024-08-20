# frozen_string_literal: true

# Model Poster caches the poster filename from TMDB.
class Poster < ApplicationRecord
  belongs_to :film

  class << self
    def for_film(film_id)
      Poster.find_by(film_id: film_id) ||
        lookup_and_create(film_id)
    end

    private

    def lookup_and_create(film_id)
      film = Film.find(film_id)
      filename = poster_client.for_movie(film.name, film.release_year)
      film.create_poster!(filename: filename)
    end

    def poster_client
      @poster_client ||= TMDB::PosterClient.new(Rails.application.config.settings.tmdb_api_read_access_token,
                                                Rails.logger)
    end
  end

  def url
    "https://image.tmdb.org/t/p/w500#{filename}"
  end
end
