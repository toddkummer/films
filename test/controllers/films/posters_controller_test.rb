# frozen_string_literal: true

require 'test_helper'

module Films
  class PostersControllerTest < ActionDispatch::IntegrationTest
    setup do
      @film = films(:one)
    end

    test 'should show film poster' do
      get film_poster_url(@film)
      assert_response :success
    end
  end
end
