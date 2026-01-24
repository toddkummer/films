# frozen_string_literal: true

module Views
  module Films
    class Show < Views::Base
      prop :film, Film, :positional

      def page_title = 'Film'
      def layout = Layout

      def view_template
        container do
          flash_notifications
          div(class: 'columns') do
            div(class: 'column') { FilmPoster(@film) }
            div(class: 'column') { film }
          end

          a(href: films_path) do
            BulmaPhlex::Icon('fas fa-arrow-left', text_right: 'Back to films')
          end
        end
      end

      private

      def film
        div(id: dom_id(@film)) do
          BulmaPhlex::Title(@film.name, subtitle: "Release Year: #{@film.release_year}")

          div(class: 'content') do
            attribute 'Production Company', @film.production_company_name
            attribute 'Distributor', @film.distributor_name
            attribute 'Locations', @film.location_names
            attribute 'Directors', @film.directors.map(&:name)
            attribute 'Writers', @film.writers.map(&:name)
            attribute 'Actors', @film.actors.map(&:name)
          end

          div(class: 'field is-grouped') do
            a(class: 'button', href: edit_film_path(@film)) { 'Edit this film' }
            button_to('Destroy this film', film_path(@film), method: :delete, class: 'button is-danger')
          end
        end
      end

      def attribute(label, content)
        div(class: 'field') do
          label(class: 'label') { label }

          content = content.first if content.is_a?(Array) && content.size == 1
          if content.is_a?(Array)
            ul(class: 'mt-1 ml-5') do
              content.each do |item|
                li { item }
              end
            end
          else
            div(class: 'ml-2') { content }
          end
        end
      end
    end
  end
end
