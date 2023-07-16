# frozen_string_literal: true

require 'application_system_test_case'

class FilmLocationsTest < ApplicationSystemTestCase
  setup do
    @film_location = film_locations(:one)
  end

  test 'visiting the index' do
    visit film_locations_url
    assert_selector 'h1', text: 'Film locations'
  end

  test 'should create film location' do
    visit film_locations_url
    click_on 'New film location'

    fill_in 'Film', with: @film_location.film_id
    fill_in 'Fun facts', with: @film_location.fun_facts
    fill_in 'Location', with: @film_location.location_id
    click_on 'Create Film location'

    assert_text 'Film location was successfully created'
    click_on 'Back'
  end

  test 'should update Film location' do
    visit film_location_url(@film_location)
    click_on 'Edit this film location', match: :first

    fill_in 'Film', with: @film_location.film_id
    fill_in 'Fun facts', with: @film_location.fun_facts
    fill_in 'Location', with: @film_location.location_id
    click_on 'Update Film location'

    assert_text 'Film location was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Film location' do
    visit film_location_url(@film_location)
    click_on 'Destroy this film location', match: :first

    assert_text 'Film location was successfully destroyed'
  end
end
