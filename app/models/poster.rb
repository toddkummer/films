# frozen_string_literal: true

# Model Poster caches the poster filename from TMDB.
class Poster < ApplicationRecord
  # ABX, CC BY-SA 4.0 <https://creativecommons.org/licenses/by-sa/4.0>, via Wikimedia Commons
  NOT_FOUND_URL = 'https://upload.wikimedia.org/wikipedia/commons/5/5f/P_Movie.svg'

  belongs_to :film

  class << self
    def for_film(film_id)
      Poster.find_by(film_id: film_id) ||
        lookup_and_create(film_id)
    end

    private

    def lookup_and_create(film_id)
      film = Film.find(film_id)
      filename = poster_client.for_movie(film.name, film.release_year).presence || NOT_FOUND_URL
      film.create_poster!(filename: filename)
    end

    def poster_client
      @poster_client ||= TMDB::PosterClient.new(Rails.application.config.settings.tmdb_api_read_access_token,
                                                Rails.logger)
    end
  end

  def url(width = 500)
    return filename if filename == NOT_FOUND_URL

    "https://image.tmdb.org/t/p/w#{width}#{filename}"
  end
end
