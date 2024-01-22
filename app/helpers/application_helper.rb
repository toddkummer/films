# frozen_string_literal: true

module ApplicationHelper
  def company_options
    companies = Company.select(:id, :name)
    options_from_collection_for_select(companies, :id, :name)
  end

  def film_poster(film)
    if film.poster.present?
      render film.poster
    elsif Rails.application.config.settings.tmdb_api_read_access_token.present?
      turbo_frame_tag(:poster, src: film_poster_path(film))
    end
  end

  def paginate(query)
    pagination = Pagination.new(query.current_page, query.total_pages)
    tag.nav(aria_label: 'pagination') do
      tag.ul(class: 'pagination') do
        pagination.links.each do |page_number, display|
          concat(tag.li do
                   pagination_link(query.model, page_number, display, current: query.current_page == page_number)
                 end)
        end
      end
    end
  end

  def pagination_link(model, page_number, display, current: false)
    link_to(display,
            [model, { params: { page: { number: page_number } } }],
            ({ 'aria-current': 'page' } if current))
  end
end
