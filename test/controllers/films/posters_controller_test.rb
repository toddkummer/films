# frozen_string_literal: true

require 'application_integration_test'

module Films
  class PostersControllerTest < ApplicationIntegrationTest
    setup do
      @film = films(:one)
    end

    test 'should show film poster' do
      sign_in
      get film_poster_url(@film)
      assert_response :success
    end
  end
end
