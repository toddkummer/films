# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  include Filterameter::DeclarativeFilters
  include NextPage::Pagination

  private

  def page_limit
    params.fetch(:limit, 5)
  end

  def build_pagination_query_params
    params.to_unsafe_h.slice('filter', 'page')
  end

  def build_filter_chips
    params.to_unsafe_h
          .fetch(:filter, {})
          .except(:sort)
          .map do |field_name, value|
      Filter.factory(field_name, value)
    end
  end
end
