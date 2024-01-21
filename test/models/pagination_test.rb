# frozen_string_literal: true

require 'test_helper'

class PaginationTest < ActiveSupport::TestCase
  def test_when_one_page
    p = Pagination.new(1, 1)

    assert_predicate p, :show_pagination?
  end

  def test_show_pagination_when_multiple_pages
    p = Pagination.new(1, 10)

    assert_not_predicate p, :show_pagination?
  end

  def test_on_first_page
    p = Pagination.new(1, 10)

    assert_not_predicate p, :show_first?
    assert_not_predicate p, :show_previous?
    assert_equal [1, 2, 3, 4, 5], p.pages
    assert_predicate p, :show_next?
    assert_predicate p, :show_last?
  end

  def test_on_second_page
    p = Pagination.new(2, 10)

    assert_not_predicate p, :show_first?
    assert_predicate p, :show_previous?
    assert_equal [1, 2, 3, 4, 5], p.pages
    assert_predicate p, :show_next?
    assert_predicate p, :show_last?
  end

  def test_in_the_middle
    p = Pagination.new(5, 10)

    assert_predicate p, :show_first?
    assert_predicate p, :show_previous?
    assert_equal [3, 4, 5, 6, 7], p.pages
    assert_predicate p, :show_next?
    assert_predicate p, :show_last?
  end

  def test_on_second_last_page
    p = Pagination.new(9, 10)

    assert_predicate p, :show_first?
    assert_predicate p, :show_previous?
    assert_equal [6, 7, 8, 9, 10], p.pages
    assert_predicate p, :show_next?
    assert_not_predicate p, :show_last?
  end

  def test_on_last_page
    p = Pagination.new(10, 10)

    assert_predicate p, :show_first?
    assert_predicate p, :show_previous?
    assert_equal [6, 7, 8, 9, 10], p.pages
    assert_not_predicate p, :show_next?
    assert_not_predicate p, :show_last?
  end
end
