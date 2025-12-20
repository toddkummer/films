# frozen_string_literal: true

require 'test_helper'

class SearchParametersTest < ActiveSupport::TestCase
  def test_build_with_all_params
    params = ActionController::Parameters.new(
      filter: { name: 'test', sort: 'name_desc' },
      page: '2'
    )
    search_params = SearchParameters.build(params, default_sort: 'name_asc')
    assert_equal({ 'name' => 'test' }, search_params.filter_params.to_unsafe_h)
    assert_equal('name_desc', search_params.sort)
    assert_equal({ 'filter' => { 'name' => 'test', 'sort' => 'name_desc' }, 'page' => { 'number' => 42 } },
                 search_params.for_page(42))
  end

  def test_with_no_filters
    params = ActionController::Parameters.new
    search_params = SearchParameters.build(params, default_sort: 'name_asc')
    assert_equal({}, search_params.filter_params.to_unsafe_h)
    assert_equal('name_asc', search_params.sort)
    assert_equal({ 'page' => { 'number' => 3 } },
                 search_params.for_page(3))
  end

  def test_build_with_no_sort
    params = ActionController::Parameters.new(
      filter: { name: 'test' },
      page: '1'
    )
    search_params = SearchParameters.build(params, default_sort: 'name_asc')
    assert_equal({ 'name' => 'test' }, search_params.filter_params.to_unsafe_h)
    assert_equal('name_asc', search_params.sort)
  end
end
