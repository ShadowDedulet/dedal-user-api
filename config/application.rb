# frozen_string_literal: true

require_relative 'boot'

require 'action_controller/railtie'
require 'action_mailer/railtie'
# require 'action_mailbox/engine'
# require 'action_text/engine'
# require 'action_view/railtie'
# require 'active_job/railtie'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_record/railtie'
# require 'active_storage/engine'
require 'rails'
require 'sprockets/railtie' # required by swagger
# require 'action_cable/engine'
# require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module UserAPI
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    config.action_mailer.default_url_options = { host: 'localhost:3000' }

    config.log_level = ENV.fetch('LOG_LEVEL', :debug)

    config.rails_semantic_logger.add_file_appender = false

    config.rails_semantic_logger.format = :json unless ENV['SEMANTIC_LOG_FORMAT'] == 'plain'
    config.semantic_logger.add_appender(
      io:          $stdout,
      formatter:   config.rails_semantic_logger.format,
      application: :'user-api')

    # Prepend all log lines with the following tags.
    config.log_tags = if ENV['SEMANTIC_LOG_FORMAT'] == 'plain'
                        %i[request_id]
                      else
                        { request_id: :request_id }
                      end

    config.hosts = [
      'dedal-nginx',
      'localhost',
      '127.0.0.1'
    ]

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = 'Central Time (US & Canada)'
    # config.eager_load_paths << Rails.root.join('extras')

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
  end
end
