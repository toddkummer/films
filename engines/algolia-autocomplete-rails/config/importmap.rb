# frozen_string_literal: true

pin_all_from File.expand_path('../app/javascript/controllers/algolia_autocomplete_rails', __dir__),
             under: 'controllers/algolia_autocomplete_rails'
pin 'algolia_autocomplete_rails/search_source', to: 'lib/algolia_autocomplete_rails/search_source.js'
