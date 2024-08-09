# frozen_string_literal: true

# # Pagination Helper
#
# Module PaginationHelper provides the helper method paginate, which takes the following arguments:
# - query: the ActiveRecord query
# - params: the params to apply to the links
module PaginationHelper
  def paginate(query, params)
    pagination = Pagination.new(query.current_page, query.total_pages)
    link_builder = lambda { |page_number|
      url_for([query.model, { params: params.deep_merge(page: { number: page_number }.compact) }])
    }

    tag.nav(aria_label: 'pagination') do
      tag.ul(class: 'pagination -space-x-px h-8 text-sm') do
        pagination_links(pagination, link_builder)
      end
    end
  end

  private

  def pagination_links(pagination, link_builder) # rubocop:disable Metrics/AbcSize
    concat render('pagination/first', href: link_builder.call(1)) if pagination.show_first?
    concat render('pagination/previous', href: link_builder.call(pagination.previous_page)) if pagination.show_previous?
    pagination.pages.each do |page|
      concat render('pagination/page_number', href: link_builder.call(page),
                                              page: page,
                                              active: pagination.current?(page))
    end
    concat render('pagination/next', href: link_builder.call(pagination.next_page)) if pagination.show_next?
    concat render('pagination/last', href: link_builder.call(pagination.last_page)) if pagination.show_last?
  end
end
