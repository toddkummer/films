# frozen_string_literal: true

require 'net/http'

module TMDB
  ## Poster Client
  #
  # Class PosterClient calls the movie search endpoint from TMDB and returns the poster path. It first
  # tries with the release year, but will try a second time without the release year if no results are found.
  #
  # TODO: Still needs a bit more error handling for when the movie is not found. For example, movie "Good
  # Neighbor Sam" has a typo in the name and is not found.
  class PosterClient
    SEARCH_MOVIE_URL = 'https://api.themoviedb.org/3/search/movie'

    def initialize(token, logger)
      @token = token
      @logger = logger
    end

    def for_movie(name, release_year = nil)
      @logger.info "[#{self.class.name}] Calling TMDB for #{name} (#{release_year})"

      results = fetch_movie(name, release_year).presence || fetch_movie(name)
      results.first['poster_path']
    end

    private

    def build_url(name, release_year)
      params = { query: name,
                 primary_release_year: release_year,
                 language: 'en-US',
                 include_adult: false,
                 page: 1 }.compact

      URI(SEARCH_MOVIE_URL).tap do |url|
        url.query = URI.encode_www_form(params)
      end
    end

    def build_request(url)
      Net::HTTP::Get.new(url).tap do |request|
        request['accept'] = 'application/json'
        request['Authorization'] = "Bearer #{@token}"
      end
    end

    def fetch_movie(name, release_year = nil)
      url = build_url(name, release_year)
      request = build_request(url)

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      # http.set_debug_output(@logger)
      response = http.request(request)
      JSON.parse(response.read_body)['results']
    end
  end
end
