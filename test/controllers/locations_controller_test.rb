# frozen_string_literal: true

require 'application_integration_test'

class LocationsControllerTest < ApplicationIntegrationTest
  setup do
    @location = locations(:one)
  end

  test 'declarations' do
    validator = LocationsController.declarations_validator
    assert_predicate validator, :valid?, -> { validator.errors }
  end

  test 'should get index' do
    sign_in
    get locations_url
    assert_response :success
  end

  test 'should show location' do
    sign_in
    get location_url(@location)
    assert_response :success
  end

  test 'should get edit' do
    sign_in
    get edit_location_url(@location)
    assert_response :success
  end

  test 'should update location' do
    sign_in
    patch location_url(@location),
          params: { location: { analysis_neighborhood_id: @location.analysis_neighborhood_id,
                                find_neighborhood_id: @location.find_neighborhood_id,
                                name: @location.name,
                                supervisor_district_id: @location.supervisor_district_id } }
    assert_redirected_to location_url(@location)
  end

  test 'should destroy location' do
    sign_in
    assert_difference('Location.count', -1) do
      delete location_url(@location)
    end

    assert_redirected_to locations_url
  end
end
