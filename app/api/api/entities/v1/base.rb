# frozen_string_literal: true

module API
  module Entities
    module V1
      class Base < Grape::Entity
        extend Helpers::FieldHelpers

        format_with :iso8601 do |date|
          date&.iso8601
        end
      end
    end
  end
end
