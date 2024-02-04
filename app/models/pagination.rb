# frozen_string_literal: true

# = Pagination
#
# Class Pagination provides the following helper methods:
# - show_pagination?
# - show_first?
# - show_previous?
# - show_next?
# - show_last?
# - pages (returns an array of page numbers)
class Pagination
  MAX_PAGE_NUMBERS_TO_SHOW = 5

  def initialize(current_page, total_pages)
    @current_page = current_page
    @total_pages = total_pages
  end

  def show_pagination?
    @total_pages > 1
  end

  def current?(page_number)
    @current_page == page_number
  end

  def show_first?
    @current_page > 2
  end

  def show_previous?
    @current_page > 1
  end

  def previous_page
    @current_page - 1
  end

  def show_next?
    @current_page < @total_pages
  end

  def next_page
    @current_page + 1
  end

  def show_last?
    @current_page < @total_pages - 1
  end

  def last_page
    @total_pages
  end

  def pages
    [@current_page].tap do |p|
      (1..MAX_PAGE_NUMBERS_TO_SHOW).each do |i|
        p.prepend(@current_page - i) if i < @current_page
        p.append(@current_page + i) if @current_page + i <= @total_pages

        break if p.size >= MAX_PAGE_NUMBERS_TO_SHOW
      end
    end
  end

  def links
    pages.map { |p| [p, p] }.tap do |number_and_display|
      number_and_display.prepend([@current_page - 1, '<']) if show_previous?
      number_and_display.prepend([1, '|<']) if show_first?
      number_and_display.append([@current_page + 1, '>']) if show_next?
      number_and_display.append([@total_pages, '>|']) if show_last?
    end
  end
end
