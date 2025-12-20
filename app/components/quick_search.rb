# frozen_string_literal: true

module Components
  # # Quick Search
  #
  # The Quick Search component provides a search input with autocomplete functionality
  # based on the sources provided. It also includes filter chips for active filters and a sort dropdown.
  #
  # ## Arguments
  #
  # - `sources` (Hash): A hash mapping field names to their respective autocomplete source identifiers.
  # - `placeholder` (String): Placeholder text for the search input. Default is 'Search'.
  # - `search_path` (String): The URL path where the search form will submit.
  # - `current_filters` (Array<Filter>): An array of Filter objects representing the currently applied filters.
  # - `sorts` (Hash): A hash mapping sort option values to their display labels.
  # - `current_sort` (String): The currently selected sort option value.
  #
  # ## Usage
  # ```ruby
  # QuickSearch.call(
  #   { name: 'NameContainsSource',
  #     locations: 'LocationsJumpToSource',
  #     film_id: 'FilmsSource' },
  #   placeholder: 'Search for films',
  #   search_path: films_path,
  #   sorts: { 'name_asc' => 'Name (A-Z)', 'name_desc' => 'Name (Z-A)' },
  #   filter_params: @filter_params, # params.to_unsafe_h.fetch(:filter, {})
  # )
  # ```
  class QuickSearch < Components::Base
    include Phlex::Rails::Helpers::FormWith
    include Phlex::Rails::Helpers::OptionsForSelect

    register_output_helper :quick_search

    prop :sources, Hash, :positional
    prop :placeholder, String, default: 'Search'
    prop :search_path, String
    prop :sorts, Hash
    prop :filter_params, ActionController::Parameters

    def view_template
      quick_search(@sources,
                   placeholder: @placeholder,
                   search_path: @search_path,
                   class: 'mb-3')

      form_with url: @search_path,
                scope: :filter,
                method: :get,
                class: 'mb-3',
                data: { controller: 'filter',
                        action: 'autocompleteSelection@document->filter#add' } do |form|
        BulmaPhlex::Level() do |level|
          level.left do
            div(class: 'field is-grouped') { filter_chips(form) }
          end

          level.right do
            div(class: 'field is-horizontal') do
              div(class: 'field-label is-normal') do
                label(for: 'filter[sort]', class: 'label') { 'Sort' }
              end
              div(class: 'field-body') do
                div(class: 'select') do
                  select(id: 'filter_sort', name: 'filter[sort]',
                         data: { controller: 'submit', action: 'submit#submit' }) do
                    options_for_select(@sorts, @filter_params['sort'])
                  end
                end
              end
            end
          end
        end
      end
    end

    private

    def filter_chips(form)
      @filter_params.except(:sort)
                    .each { |field_name, value| filter_chip(form, field_name, value) }
    end

    def filter_chip(form, field_name, value)
      filter = Filter.factory(field_name, value)
      div(class: 'control') do
        form.hidden_field filter.field_name, value: filter.value
        div(class: 'tags has-addons') do
          span(class: 'tag is-link') { filter.label }
          a(class: 'tag is-delete',
            data: { action: 'click->filter#remove' })
        end
      end
    end
  end
end
