# frozen_string_literal: true

module Films
  # Controller Films::PostersController shows the poster for a film.
  class PostersController < ApplicationController
    before_action :set_poster, only: %i[show]

    def show; end

    private

    def set_poster
      @poster = Poster.for_film(params[:film_id])
    end
  end
end
