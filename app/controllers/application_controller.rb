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

  def build_pagination_query_params
    params.to_unsafe_h.slice('filter', 'page')
  end
end
