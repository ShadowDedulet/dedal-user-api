# frozen_string_literal: true

module API
  module Entities
    module V1
      class Error < Base
        expose :ok, default: false, documentation: { type: boolean, default: false, desc: 'ok?' }

        expose :title,     documentation: { type: String, desc: 'Description'           }
        expose :backtrace, documentation: { type: String, is_array: true, desc: 'Trace' }

        unexpose :backtrace if Rails.env.production?
      end
    end
  end
end
