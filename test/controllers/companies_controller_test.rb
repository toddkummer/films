# frozen_string_literal: true

require 'application_integration_test'

class CompaniesControllerTest < ApplicationIntegrationTest
  setup do
    @company = companies(:one)
  end

  test 'should get index' do
    sign_in
    get companies_url
    assert_response :success
  end

  test 'should get new' do
    sign_in
    get new_company_url
    assert_response :success
  end

  test 'should create company' do
    sign_in

    assert_difference('Company.count') do
      post companies_url, params: { company: { name: @company.name } }
    end

    assert_redirected_to company_url(Company.last)
  end

  test 'should show company' do
    sign_in
    get company_url(@company)
    assert_response :success
  end

  test 'should get edit' do
    sign_in
    get edit_company_url(@company)
    assert_response :success
  end

  test 'should update company' do
    sign_in
    patch company_url(@company), params: { company: { name: @company.name } }
    assert_redirected_to company_url(@company)
  end

  test 'should destroy company' do
    sign_in

    assert_difference('Company.count', -1) do
      delete company_url(@company)
    end

    assert_redirected_to companies_url
  end
end
