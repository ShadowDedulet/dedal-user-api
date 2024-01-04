# frozen_string_literal: true

module Helpers
  module RequestHelpers
    def json_response(response = self.response)
      JSON.parse(response.body, symbolize_names: true)
    end

    def response_data(response = self.response)
      json_response(response)[:data]
    end

    def response_errors(response = self.response)
      json_response(response)[:errors]
    end

    def response_error(response = self.response)
      errors = response_errors(response)
      raise StandardError, 'Multiple errors detected' unless errors.one?

      errors.first
    end
  end
end
