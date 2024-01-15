# frozen_string_literal: true

require 'test_helper'

class FilmsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @film = films(:one)
  end

  test 'should get index' do
    get films_url
    assert_response :success
  end

  test 'should get index with name criteria' do
    get films_url(params: { filter: { name: 'bears' } })
    assert_response :success
  end

  test 'should get new' do
    get new_film_url
    assert_response :success
  end

  test 'should create film' do
    assert_difference('Film.count') do
      post films_url,
           params: { film: { distributor_id: @film.distributor_id, name: @film.name,
                             production_company_id: @film.production_company_id, release_year: @film.release_year } }
    end

    assert_redirected_to film_url(Film.last)
  end

  test 'should show film' do
    get film_url(@film)
    assert_response :success
  end

  test 'should get edit' do
    get edit_film_url(@film)
    assert_response :success
  end

  test 'should update film' do
    patch film_url(@film),
          params: { film: { distributor_id: @film.distributor_id, name: @film.name,
                            production_company_id: @film.production_company_id, release_year: @film.release_year } }
    assert_redirected_to film_url(@film)
  end

  test 'should destroy film' do
    assert_difference('Film.count', -1) do
      delete film_url(@film)
    end

    assert_redirected_to films_url
  end
end
