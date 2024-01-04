# frozen_string_literal: true

module API
  module Exceptions
    class Base < StandardError
      MESSAGE = 'API base error'
      public_constant :MESSAGE

      def initialize(message = self.class::MESSAGE)
        super(message)
      end
    end
  end
end
