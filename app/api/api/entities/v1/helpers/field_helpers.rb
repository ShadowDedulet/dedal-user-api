# frozen_string_literal: true

module API
  module Entities
    module V1
      module Helpers
        module FieldHelpers
          extend ActiveSupport::Concern

          def default
            represent({}).as_json
          end

          def date_time(**args)
            { documentation: { type: DateTime }, format_with: :iso8601 }.merge(**args)
          end
        end
      end
    end
  end
end
