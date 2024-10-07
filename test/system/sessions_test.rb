# frozen_string_literal: true

require 'application_system_test_case'

class SessionsTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test 'should create session' do
    visit new_session_url
    fill_in 'Email', with: @user.email_address
    fill_in 'Password', with: 'password' # Use the correct password for your fixture
    click_on 'Sign in'

    assert_current_path root_path
  end

  test 'should not create session with invalid credentials' do
    visit new_session_url
    fill_in 'Email', with: @user.email_address
    fill_in 'Password', with: 'wrongpassword'
    click_on 'Sign in'

    assert_text 'Try another email address or password.'
    assert_current_path new_session_path
  end

  test 'should destroy session' do
    skip 'Should there be a Logout button?'
    visit new_session_url
    fill_in 'Email', with: @user.email_address
    fill_in 'Password', with: 'password' # Use the correct password for your fixture
    click_on 'Sign in'

    click_on 'Logout'
    assert_text 'Logged out successfully'
    assert_current_path root_path
  end
end
