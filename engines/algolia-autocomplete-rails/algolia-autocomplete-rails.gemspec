# frozen_string_literal: true

require_relative 'lib/algolia_autocomplete_rails/version'

Gem::Specification.new do |spec|
  spec.name          = 'algolia-autocomplete-rails'
  spec.version       = AlgoliaAutocompleteRails::VERSION
  spec.authors       = ['Todd Kummer']
  spec.email         = ['todd@rockridgesolutions.com']

  spec.summary       = "Helpers to implement Algolia's autocomplete.js in Rails with Stimulus"
  spec.description   = "Leverage Algolia's Autocomplete library through view helpers and Stimulus controllers."
  spec.homepage      = 'http://github.com/RockSolt/algolia-autocomplete-rails'
  spec.license       = 'MIT'

  spec.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  spec.bindir = 'exe'

  spec.required_ruby_version = '>= 3.4'

  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_dependency 'rails', '>= 7.1'
  spec.add_dependency 'stimulus-rails', '>= 1.2'
end
