# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  include Filterameter::DeclarativeFilters
  include NextPage::Pagination
  include Phlexable

  private

  def page_limit
    params.fetch(:limit, 5)
  end
end
