# frozen_string_literal: true

module Films
  # Controller Films::PostersController shows the poster for a film.
  class PostersController < ApplicationController
    layout false

    def show
      width = params[:width]
      width = if width.present?
                width.to_i
              else
                500
              end
      render phlex(Poster.for_film(params[:film_id]), width:)
    end
  end
end
