# frozen_string_literal: true

module API
  module Entities
    module V1
      class Success < Base
        expose :ok, default: true, documentation: { type: Grape::API::Boolean, default: true, desc: 'ok' }
      end
    end
  end
end
