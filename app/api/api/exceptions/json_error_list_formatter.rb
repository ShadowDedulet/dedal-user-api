# frozen_string_literal: true

module API
  module Exceptions
    module JsonErrorListFormatter
      extend ActiveSupport::Concern

      def self.call(messages, _backtrace, _options, _env, _original_exception)
        errors = Array(messages).map { |message| { title: message } }
        API::Entities::V1::ErrorList.represent(errors:).to_json
      end
    end
  end
end
