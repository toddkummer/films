# frozen_string_literal: true

module ApplicationHelper
  def company_options
    companies = Company.select(:id, :name)
    options_from_collection_for_select(companies, :id, :name)
  end
end
