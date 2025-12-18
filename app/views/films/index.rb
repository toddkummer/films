# frozen_string_literal: true

module Views
  module Films
    class Index < Views::Base
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::OptionsForSelect

      prop :films, ActiveRecord::Relation, :positional
      prop :filter_chips, _Array(Filter)
      prop :query_params, Hash
      prop :sort, String

      register_output_helper :quick_search

      def page_title = 'Films'
      def layout = Layout

      def view_template
        container do
          BulmaPhlex::Title('Films')
          flash_notifications

          quick_search({ name: 'NameContainsSource',
                         films: 'FilmsJumpToSource',
                         location_id: 'LocationsSource',
                         director_id: 'DirectorsSource',
                         writer_id: 'WritersSource',
                         actor_id: 'ActorsSource' },
                       placeholder: 'Search for films',
                       class: 'my-3')

          search_form

          div(class: 'columns is-multiline is-variable is-2') do
            @films.each { |f| film_tile(f) }
          end

          BulmaPhlex::Pagination(@films, ->(page) { films_path(@query_params.merge(page: { number: page })) })
        end
      end

      private

      def search_form
        form_with url: films_path,
                  scope: :filter,
                  method: :get,
                  data: { controller: 'filter',
                          action: 'autocompleteSelection@document->filter#add' } do |form|
          div(class: 'level mb-3') do
            div(class: 'level-left') do
              div(class: 'level-item') do
                div(class: 'field is-grouped') do
                  @filter_chips.each { filter_chip(form, it) }
                end
              end
            end

            div(class: 'level-right') do
              div(class: 'level-item') do
                div(class: 'field is-horizontal') do
                  div(class: 'field-label is-normal') do
                    label(for: 'filter[sort]', class: 'label') { 'Sort' }
                  end
                  div(class: 'field-body') do
                    div(class: 'select') do
                      select(id: 'filter_sort', name: 'filter[sort]',
                             data: { controller: 'submit', action: 'submit#submit' }) do
                        options_for_select({ 'Newest first' => '-release_year',
                                             'Oldest first' => 'release_year',
                                             'Film name' => 'name' },
                                           @sort)
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end

      def filter_chip(form, filter)
        div(class: 'control') do
          form.hidden_field filter.field_name, value: filter.value
          div(class: 'tags has-addons') do
            span(class: 'tag is-link') { filter.label }
            a(class: 'tag is-delete',
              data: { action: 'click->filter#remove' })
          end
        end
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
