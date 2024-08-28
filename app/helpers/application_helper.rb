# frozen_string_literal: true

module ApplicationHelper
  def company_options
    companies = Company.select(:id, :name)
    options_from_collection_for_select(companies, :id, :name)
  end

  def film_poster(film, width = 500)
    if film.poster.present?
      render film.poster, width: width
    elsif Rails.application.config.settings.tmdb_api_read_access_token.present?
      turbo_frame_tag(:poster, src: film_poster_path(film, params: { width: width }), loading: 'lazy')
    end
  end
end
