# frozen_string_literal: true

module Views
  module People
    class Show < Views::Base
      prop :person, Person, :positional

      def page_title = 'Person'
      def layout = Layout

      def view_template
        container do
          flash_notifications

          div(class: 'content') do
            BulmaPhlex::Title(@person.name)

            BulmaPhlex::Card() do |card|
              card.head('Acting Credits')
              card.content do
                if @person.acting_credits.any?
                  div(class: 'grid') do
                    @person.acting_credits.each { |credit| poster(credit.film) }
                  end
                else
                  p { 'No acting credits found.' }
                end
              end
            end
          end

          div(class: 'field is-grouped') do
            a(class: 'button', href: edit_person_path(@person)) { 'Edit this person' }
            button_to('Destroy this person', person_path(@person), method: :delete, class: 'button is-danger')
          end

          a(href: people_path) { 'Back to people' }
        end
      end

      private

      # def film_links(films)
      #   films.map do |f|
      #     LINK_CONTENT.new(name: f.name, href: film_path(f))
      #   end
      # end

      def poster(film)
        a(href: film_path(film), class: 'cell') do
          FilmPoster(film, width: 200)
        end
      end
    end
  end
end
