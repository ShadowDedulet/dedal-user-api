# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

ruby '3.2.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 7.1.2'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# PostgreSQL
gem 'pg', '~> 1.5.4'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', '~> 2.0', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.17', require: false

# Logging (todo: add logger middleware)
gem 'rails_semantic_logger', '~> 4.14'

# Authorization
gem 'devise', '~> 4.9.3'
gem 'devise-jwt', '~> 0.11.0'
gem 'jwt', '~> 2.7.1'

# Grape + Swagger
gem 'grape', '~> 2.0.0'
gem 'grape-entity', '~> 1.0.0'
gem 'grape-swagger', '~> 2.0.0'
gem 'grape-swagger-entity', '~> 0.5.2'
gem 'grape-swagger-rails', '~> 0.4.0'
gem 'sprockets-rails', '~> 3.4.2'

group :development, :test do
  gem 'byebug', '~> 11.1'
  gem 'error_highlight', '>= 0.4.0', platforms: [:ruby]
  gem 'factory_bot_rails', '~> 6.4.2' # for using generators and rake tasks without RAILS_ENV=test
  gem 'rspec-rails', '~> 6.0.0' # for using generators and rake tasks without RAILS_ENV=test
  gem 'rubocop', '~> 1.59'
  gem 'rubocop-factory_bot', '~> 2.24.0'
  gem 'rubocop-performance', '~> 1.19'
  gem 'rubocop-rails', '~> 2.23.1'
  gem 'rubocop-rspec', '~> 2.25'
end

group :test do
  gem 'faker', '~> 3.2.2'
  gem 'rspec_junit_formatter', '~> 0.6.0', require: false
  gem 'simplecov', '~> 0.22.0', require: false
  gem 'simplecov-cobertura', '~> 2.1', require: false
  gem 'timecop', '~> 0.9.8'
  gem 'webmock', '~> 3.19'
end
