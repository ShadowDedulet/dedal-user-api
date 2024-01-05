# frozen_string_literal: true

module API
  module Exceptions
    class Base < StandardError
      MESSAGE = 'API base error'
      public_constant :MESSAGE

      CODE = 500
      public_constant :CODE

      def self.to_swagger_response
        { code: self::CODE, message: self::MESSAGE, model: API::Entities::V1::Error }
      end

      def initialize(message = self.class::MESSAGE)
        super(message)
      end
    end
  end
end
