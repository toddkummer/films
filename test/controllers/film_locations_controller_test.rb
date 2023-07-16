# frozen_string_literal: true

require 'test_helper'

class FilmLocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @film_location = film_locations(:one)
  end

  test 'should get index' do
    get film_locations_url
    assert_response :success
  end

  test 'should get new' do
    get new_film_location_url
    assert_response :success
  end

  test 'should create film_location' do
    assert_difference('FilmLocation.count') do
      post film_locations_url,
           params: { film_location: { film_id: @film_location.film_id, fun_facts: @film_location.fun_facts,
                                      location_id: @film_location.location_id } }
    end

    assert_redirected_to film_location_url(FilmLocation.last)
  end

  test 'should show film_location' do
    get film_location_url(@film_location)
    assert_response :success
  end

  test 'should get edit' do
    get edit_film_location_url(@film_location)
    assert_response :success
  end

  test 'should update film_location' do
    patch film_location_url(@film_location),
          params: { film_location: { film_id: @film_location.film_id, fun_facts: @film_location.fun_facts,
                                     location_id: @film_location.location_id } }
    assert_redirected_to film_location_url(@film_location)
  end

  test 'should destroy film_location' do
    assert_difference('FilmLocation.count', -1) do
      delete film_location_url(@film_location)
    end

    assert_redirected_to film_locations_url
  end
end
