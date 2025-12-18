# frozen_string_literal: true

module Views
  module Companies
    class Index < Views::Base
      prop :companies, ActiveRecord::Relation, :positional

      def page_title = 'Companies'
      def layout = Layout

      def view_template
        container('is-max-tablet') do
          flash_notifications

          BulmaPhlex::Title('Companies')
          ul do
            @companies.each do |company|
              li do
                a(href: company_path(company)) { company.name }
              end
            end
          end
          BulmaPhlex::Pagination(@companies, ->(page) { companies_path(page: { number: page }) })
        end
      end
    end
  end
end
