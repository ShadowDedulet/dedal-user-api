# frozen_string_literal: true

module Helpers
  module RequestHelpers
    def json_response(response = self.response)
      JSON.parse(response.body, symbolize_names: true)
    end

    def response_data(response = self.response)
      json_response(response)[:data]
    end

    def response_error(response = self.response)
      json_response(response)
    end

    def factory_to_entity(factory_instance, entity_klass)
      js = entity_klass.represent(factory_instance).as_json.deep_symbolize_keys
      js = js[:data] if entity_klass.default.key?('data')
      js
    end
  end
end
