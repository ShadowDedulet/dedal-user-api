# frozen_string_literal: true

module API
  module Entities
    module V1
      class Error < Base
        expose :title, documentation: { type: String, desc: 'Описание ошибки' }
      end
    end
  end
end
