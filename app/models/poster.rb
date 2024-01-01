# frozen_string_literal: true

# Model Poster caches the poster filename from TMDB.
class Poster < ApplicationRecord
  belongs_to :film

  def self.for_film(film_id)
    Poster.find_by(film_id: film_id) ||
      lookup_and_create(film_id)
  end

  def self.lookup_and_create(film_id)
    film = Film.find(film_id)
    filename = TMDB::PosterClient.new(Rails.application.config.settings.tmdb_api_read_access_token,
                                      Rails.logger)
                                 .for_movie(film.name, film.release_year)
    film.create_poster!(filename: filename)
  end

  def url
    "https://image.tmdb.org/t/p/w500#{filename}"
  end
end
