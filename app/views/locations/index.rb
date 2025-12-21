# frozen_string_literal: true

module Views
  module Locations
    class Index < Views::Base
      prop :locations, ActiveRecord::Relation(Location), :positional
      prop :search_params, SearchParameters

      def page_title = 'Locations'
      def layout = Layout

      def view_template
        container('is-max-desktop') do
          BulmaPhlex::Title('Locations')
          flash_notifications

          QuickSearch(search_sources,
                      placeholder: 'Search for films',
                      search_path: locations_path,
                      search_params: @search_params,
                      sort_options: { 'Location name' => 'name',
                                      'Location name (desc)' => '-name' })

          ul do
            @locations.each do |location|
              li do
                a(href: location_path(location)) { location.name }
              end
            end
          end
          BulmaPhlex::Pagination(@locations, ->(page) { locations_path(page: { number: page }) })
        end
      end

      private

      def search_sources
        { name: 'NameContainsSource',
          locations: 'LocationsJumpToSource',
          film_id: 'FilmsSource' }
      end
    end
  end
end
