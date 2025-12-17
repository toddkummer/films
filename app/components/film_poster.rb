# frozen_string_literal: true

module Components
  # # Film Poster
  #
  # This shows the poster for a film. If the poster has not yet been fetched, this
  # will create a Turbo Frame that will load the poster asynchronously.
  class FilmPoster < Components::Base
    include Phlex::Rails::Helpers::DOMID
    include Phlex::Rails::Helpers::TurboFrameTag

    prop :film, Film, :positional
    prop :width, Integer, default: 500

    def view_template
      if @film.poster.present?
        Poster(@film.poster, width: @width)
      elsif Rails.application.config.settings.tmdb_api_read_access_token.present?
        turbo_frame_tag(:poster, src: film_poster_path(@film, params: { width: @width }), loading: 'lazy')
      end
    end
  end
end
