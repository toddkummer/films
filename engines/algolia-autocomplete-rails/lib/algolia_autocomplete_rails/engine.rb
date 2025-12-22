# frozen_string_literal: true

module AlgoliaAutocompleteRails
  # Rails Engine provides asset pipeline and importmap integration
  class Engine < ::Rails::Engine
    initializer 'algolia_autocomplete_rails.assets' do |app|
      app.config.assets.paths << root.join('app/javascript')
    end

    initializer 'algolia-autocomplete-rails.importmap', before: 'importmap' do |app|
      app.config.importmap.paths << Engine.root.join('config/importmap.rb') if app.config.respond_to?(:importmap)
    end
  end
end
