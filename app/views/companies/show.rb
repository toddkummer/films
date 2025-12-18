# frozen_string_literal: true

module Views
  module Companies
    class Show < Views::Base
      prop :company, Company, :positional

      def page_title = 'Company'
      def layout = Layout

      def view_template
        container do
          flash_notifications
          div(class: 'content') do
            BulmaPhlex::Title(@company.name)

            div(class: 'columns') do
              div(class: 'column') do
                show_links('Productions', film_links(@company.film_productions))
              end
              div(class: 'column') do
                show_links('Distributions', film_links(@company.film_distributions))
              end
            end
          end

          div(class: 'field is-grouped') do
            a(class: 'button', href: edit_company_path(@company)) { 'Edit this company' }
            button_to('Destroy this company', company_path(@company), method: :delete, class: 'button is-danger')
          end

          a(href: companies_path) { 'Back to companies' }
        end
      end

      private

      def film_links(films)
        films.map do |f|
          LINK_CONTENT.new(name: f.name, href: film_path(f))
        end
      end
    end
  end
end
