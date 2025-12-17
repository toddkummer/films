# frozen_string_literal: true

module Films
  # Controller Films::PostersController shows the poster for a film.
  class PostersController < ApplicationController
    layout false

    def show
      render phlex(
        Poster.for_film(params[:film_id]),
        width: params[:width] || 500
      )
    end
  end
end
