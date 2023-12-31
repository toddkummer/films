# frozen_string_literal: true

module Films
  # = Film Posters Controller
  #
  # Class Films::PostersController shows the poster for a film.
  class PostersController < ApplicationController
    before_action :set_poster, only: %i[show]

    private

    def set_poster
      @poster = Poster.find_by(params[:film_id]) || fetch_poster_info
    end

    def fetch_poster_info
      Poster.new
    end
  end
end
