# frozen_string_literal: true

require 'application_system_test_case'

class LocationsTest < ApplicationSystemTestCase
  setup do
    @location = locations(:one)
  end

  test 'visiting the index' do
    visit locations_url
    assert_selector 'h1', text: 'Locations'
  end

  test 'should update Location' do
    visit location_url(@location)
    click_on 'Edit this location', match: :first

    fill_in 'Analysis neighborhood', with: @location.analysis_neighborhood_id
    fill_in 'Find neighborhood', with: @location.find_neighborhood_id
    fill_in 'Name', with: @location.name
    fill_in 'Supervisor district', with: @location.supervisor_district_id
    click_on 'Update Location'

    assert_text 'Location was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Location' do
    visit location_url(@location)
    click_on 'Destroy this location', match: :first

    assert_text 'Location was successfully destroyed'
  end
end
