# frozen_string_literal: true

require 'test_helper'

class ApplicationIntegrationTest < ActionDispatch::IntegrationTest
  private

  def sign_in(user = users(:one))
    post session_url(params: { email_address: user.email_address, password: 'password' })
  end
end
