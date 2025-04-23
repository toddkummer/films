# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  private

  def sign_in_as(user, password = 'CQiHmDt4aHMH')
    visit new_session_url
    fill_in 'Email', with: user.email_address
    fill_in 'Password', with: password
    click_on 'Sign in'
    assert_current_path root_path
  end

  def sign_in
    sign_in_as(users(:one))
  end
end
