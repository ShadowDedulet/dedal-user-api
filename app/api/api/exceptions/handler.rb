# frozen_string_literal: true

module API
  module Exceptions
    module Handler
      extend ActiveSupport::Concern

      included do
        error_formatter :json, JsonErrorFormatter

        def self.rescue_from(*args, &)
          blk = proc do |ex|
            @env[:original_exception] = ex
            instance_exec(ex, &)
          end

          super(*args, &blk)
        end

        rescue_from API::Exceptions::Unauthorized do |e|
          error!(e.message, :unauthorized) # 401
        end

        rescue_from API::Exceptions::PageNotFound, ActiveRecord::RecordNotFound do |e|
          error!(e.message, :not_found) # 404
        end

        rescue_from NotImplementedError do |e|
          error!(e.message, :not_implemented) # 501
        end

        rescue_from StandardError do |e|
          error!(e.message, :internal_server_error) # 500
        end
      end
    end
  end
end
