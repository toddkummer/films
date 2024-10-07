# frozen_string_literal: true

require 'application_integration_test'

class PeopleControllerTest < ApplicationIntegrationTest
  setup do
    @person = people(:one)
  end

  test 'declarations' do
    validator = PeopleController.declarations_validator
    assert_predicate validator, :valid?, -> { validator.errors }
  end

  test 'should get index' do
    sign_in
    get people_url
    assert_response :success
  end

  test 'should get new' do
    sign_in
    get new_person_url
    assert_response :success
  end

  test 'should create person' do
    sign_in

    assert_difference('Person.count') do
      post people_url, params: { person: { name: @person.name } }
    end

    assert_redirected_to person_url(Person.last)
  end

  test 'should show person' do
    sign_in

    get person_url(@person)
    assert_response :success
  end

  test 'should get edit' do
    sign_in
    get edit_person_url(@person)
    assert_response :success
  end

  test 'should update person' do
    sign_in
    patch person_url(@person), params: { person: { name: @person.name } }
    assert_redirected_to person_url(@person)
  end

  test 'should destroy person' do
    sign_in

    assert_difference('Person.count', -1) do
      delete person_url(@person)
    end

    assert_redirected_to people_url
  end
end
