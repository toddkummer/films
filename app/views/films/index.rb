# frozen_string_literal: true

module Views
  module Films
    class Index < Views::Base
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::OptionsForSelect

      prop :films, ActiveRecord::Relation, :positional
      prop :search_params, SearchParameters

      def page_title = 'Films'
      def layout = Layout

      def view_template
        container do
          BulmaPhlex::Title('Films')
          flash_notifications

          QuickSearch(search_sources,
                      placeholder: 'Search for films',
                      search_path: films_path,
                      search_params: @search_params,
                      sort_options:)

          div(class: 'columns is-multiline is-variable is-2') do
            @films.each { |f| film_tile(f) }
          end

          BulmaPhlex::Pagination(@films, ->(page) { films_path(@search_params.for_page(page)) })
        end
      end

      private

      def search_sources
        { name: 'NameContainsSource',
          films: 'FilmsJumpToSource',
          location_id: 'LocationsSource',
          director_id: 'DirectorsSource',
          writer_id: 'WritersSource',
          actor_id: 'ActorsSource' }
      end

      def sort_options
        { 'Newest first' => '-release_year',
          'Oldest first' => 'release_year',
          'Film name' => 'name' }
      end

      def film_tile(film)
        div(class: 'column is-full-mobile is-full-tablet is-half-desktop is-one-third-fullhd') do
          a(href: film_path(film), class: 'box') do
            article(class: 'media') do
              div(class: 'media-left') do
                Components::FilmPoster(film, width: 200)
              end

              div(class: 'media-content') do
                div(class: 'content') do
                  BulmaPhlex::Title(film.name, size: 4)
                  unless film.location_names.empty?
                    p do
                      "Filmed at #{film.location_names.to_sentence}.".truncate(220, separator: ' ')
                    end
                  end
                  p { "Starring #{film.actors.map(&:name).to_sentence}." }
                  p { "Directed by #{film.directors.map(&:name).to_sentence}, #{film.release_year}." }
                end
              end
            end
          end
        end
      end
    end
  end
end
