# frozen_string_literal: true

# # Quick Search Helper
#
# Helper quick_search generates an Algolia Autocomplete instance. Use the following arguments:
# - sources: A hash with the search key as the key and the name of the source as the value. If there is only one source
#   and no search key is required, the source can be passed as a string.
# - placeholder: The placeholder string for the search box.
# - html_options: any html options to be added to the outer div
#
# ## Examples
#
# Here is an example of a search across projects and activities:
#
#     quick_search({ projects: 'ProjectsSource',
#                    activities: 'ActivitySource'},
#                  placeholder: 'Search for projects or activities',
#                  class: 'search-container projects-search')
#
# Here is an exmaple of a user search with a single source:
#
#     quick_search('UserSource', placeholder: 'Select a User')
module QuickSearchHelper
  def quick_search(sources, placeholder: 'Search', **html_options)
    sources = { sources => sources } if sources.is_a? String
    data = (html_options.delete(:data) || {})
           .merge(controller: 'quicksearch',
                  quicksearch_placeholder_value: placeholder,
                  quicksearch_source_mapping_value: sources.to_json)
    tag.div(data: data, **html_options) do
      tag.div(data: { quicksearch_target: 'searchInput' })
    end
  end
end
