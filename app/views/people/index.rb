# frozen_string_literal: true

module Views
  module People
    class Index < Views::Base
      prop :people, ActiveRecord::Relation(Person), :positional

      def page_title = 'People'
      def layout = Layout

      def view_template
        container('is-max-tablet') do
          flash_notifications

          BulmaPhlex::Title('People')
          ul do
            @people.each do |person|
              li do
                a(href: person_path(person)) { person.name }
              end
            end
          end
          BulmaPhlex::Pagination(@people, ->(page) { people_path(page: { number: page }) })
        end
      end
    end
  end
end
