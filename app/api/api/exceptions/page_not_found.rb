# frozen_string_literal: true

module API
  module Exceptions
    class PageNotFound < Base
      MESSAGE = 'Page not found'
      public_constant :MESSAGE

      CODE = 404
      public_constant :CODE
    end
  end
end
