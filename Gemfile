# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: '.ruby-version'

gem 'filterameter', '~> 1.0'
# gem 'filterameter', github: 'RockSolt/filterameter', branch: 'rails-7.2'
gem 'next_page', '~> 1.0'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.0.1'

gem 'propshaft'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 2.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 6.4'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Sass to process CSS
# gem "sassc-rails"

gem 'bulma-phlex', github: 'rocksolt/bulma-phlex', branch: 'main'
gem 'bulma-phlex-rails', github: 'rocksolt/bulma-phlex-rails', branch: 'main'
gem 'csv', '~> 3.3'
gem 'literal', '~> 1.8'
gem 'phlex-rails', '~> 2.3.1'

# https://github.com/ruby/openssl/issues/949
gem 'openssl', '~> 3.3', '>= 3.3.1'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'guard', '~> 2.18.0'
  gem 'guard-minitest', '~> 2.4.6'
  gem 'guard-rubocop', '~> 1.5.0'
  gem 'rubocop', '~> 1.54', require: false
  gem 'rubocop-rails', '~> 2.25.1', require: false
  gem 'web-console'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'minitest', '~> 5.25'
  gem 'selenium-webdriver'
end
