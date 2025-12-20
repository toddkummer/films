# frozen_string_literal: true

# # Search Parameters
#
# This value object encapsulates the logic for extracting and building
# search-related parameters from a set of request parameters.
class SearchParameters < Literal::Data
  # Builds a SearchParameters instance from the request params and a default sort order.
  def self.build(params, default_sort:)
    new(
      filter_params: params.fetch(:filter, {}).except(:sort),
      sort: params.dig(:filter, :sort) || default_sort,
      query_params: params.slice(:filter, :page)
    )
  end

  prop :filter_params, ActionController::Parameters
  prop :sort, String
  prop :query_params, ActionController::Parameters, reader: :private

  # Returns a new set of query parameters with the specified page number.
  def for_page(page_number)
    @query_params.to_unsafe_h.merge(page: { number: page_number })
  end
end
