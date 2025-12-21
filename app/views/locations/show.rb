# frozen_string_literal: true

module Views
  module Locations
    class Show < Views::Base
      prop :location, Location, :positional

      def page_title = 'Location'
      def layout = Layout

      def view_template
        container do
          BulmaPhlex::Title(@location.name)
          flash_notifications

          div(class: 'grid') do
            @location.film_locations.map(&:film).each do |film|
              a(href: film_path(film), class: 'box cell') do
                FilmPoster(film, width: 200)
              end
            end
          end

          div(class: 'field is-grouped') do
            a(class: 'button', href: edit_location_path(@location)) { 'Edit this location' }
            button_to('Destroy this location', location_path(@location), method: :delete, class: 'button is-danger')
          end

          a(href: locations_path) { 'Back to locations' }
        end
      end
    end
  end
end
