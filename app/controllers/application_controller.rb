# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Filterameter::DeclarativeControllerFilters

  private

  def page_limit
    params.fetch(:limit, 5)
  end
end
