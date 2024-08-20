# frozen_string_literal: true

require 'test_helper'

module Films
  class PosterTest < ActiveSupport::TestCase
    def test_for_film_with_poster
      film = films(:one)
      assert_equal film.poster, Poster.for_film(film.id)
    end

    def test_for_film_without_poster_calls_poster_client_for_movie
      film = films(:no_poster)
      pcm = poster_client_mock(film.name, film.release_year)
      Poster.stub :poster_client, pcm do
        poster = Poster.for_film(film.id)
        assert_equal '/the_poster', poster.filename
      end

      assert_mock pcm
    end

    private

    def poster_client_mock(name, release_year)
      mock = Minitest::Mock.new
      mock.expect :for_movie, '/the_poster', [name, release_year]
      mock
    end
  end
end
