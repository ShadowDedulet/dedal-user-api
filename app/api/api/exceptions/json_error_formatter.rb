# frozen_string_literal: true

module API
  module Exceptions
    module JsonErrorFormatter
      extend ActiveSupport::Concern

      def self.call(_message, _backtrace, _options, env, _original_exception)
        exc = env[:original_exception]
        API::Entities::V1::Error.represent(title: exc.message, backtrace: exc.backtrace).to_json
      end
    end
  end
end
