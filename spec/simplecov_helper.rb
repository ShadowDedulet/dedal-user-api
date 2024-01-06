# frozen_string_literal: true

if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-cobertura'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
                                                                   SimpleCov::Formatter::HTMLFormatter,
                                                                   SimpleCov::Formatter::CoberturaFormatter
                                                                 ])

  SimpleCov.coverage_dir ENV.fetch('COVERAGE_DIR', 'coverage')

  SimpleCov.start 'rails' do
    enable_coverage :branch
    groups.clear

    add_group 'API', 'app/api'
    add_group 'Models', 'app/models'
    add_group 'Logging', %w[app/models/log_event.rb app/api/api/middleware/logger.rb]
  end
end
