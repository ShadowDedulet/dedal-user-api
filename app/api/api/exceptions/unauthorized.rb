# frozen_string_literal: true

module API
  module Exceptions
    class Unauthorized < Base
      MESSAGE = 'User unauthorized'
      public_constant :MESSAGE

      CODE = 401
      public_constant :CODE
    end
  end
end
