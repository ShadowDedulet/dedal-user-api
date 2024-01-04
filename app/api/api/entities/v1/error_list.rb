# frozen_string_literal: true

module API
  module Entities
    module V1
      class ErrorList < Base
        expose :errors, documentation: { type: API::Entities::V1::Error, is_array: true, desc: 'Список ошибок' }
      end
    end
  end
end
