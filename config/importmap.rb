# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin_all_from 'app/javascript/src', under: 'src'

pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin '@algolia/autocomplete-js', to: 'https://ga.jspm.io/npm:@algolia/autocomplete-js@1.10.0/dist/esm/index.js'
pin '@algolia/autocomplete-core', to: 'https://ga.jspm.io/npm:@algolia/autocomplete-core@1.10.0/dist/esm/index.js'
pin '@algolia/autocomplete-plugin-algolia-insights', to: 'https://ga.jspm.io/npm:@algolia/autocomplete-plugin-algolia-insights@1.10.0/dist/esm/index.js'
pin '@algolia/autocomplete-preset-algolia', to: 'https://ga.jspm.io/npm:@algolia/autocomplete-preset-algolia@1.10.0/dist/esm/index.js'
pin '@algolia/autocomplete-shared', to: 'https://ga.jspm.io/npm:@algolia/autocomplete-shared@1.10.0/dist/esm/index.js'
pin '@algolia/autocomplete-shared/dist/esm/core', to: 'https://ga.jspm.io/npm:@algolia/autocomplete-shared@1.10.0/dist/esm/core/index.js'
pin '@algolia/autocomplete-shared/dist/esm/js', to: 'https://ga.jspm.io/npm:@algolia/autocomplete-shared@1.10.0/dist/esm/js/index.js'
pin '@algolia/autocomplete-shared/dist/esm/preset-algolia/algoliasearch', to: 'https://ga.jspm.io/npm:@algolia/autocomplete-shared@1.10.0/dist/esm/preset-algolia/algoliasearch.js'
pin '@algolia/autocomplete-shared/dist/esm/preset-algolia/createRequester', to: 'https://ga.jspm.io/npm:@algolia/autocomplete-shared@1.10.0/dist/esm/preset-algolia/createRequester.js'
pin 'htm', to: 'https://ga.jspm.io/npm:htm@3.1.1/dist/htm.module.js'
pin 'preact', to: 'https://ga.jspm.io/npm:preact@10.16.0/dist/preact.module.js'
