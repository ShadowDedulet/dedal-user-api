# frozen_string_literal: true

module API
  module V1
    module Helpers
      module GrapeHelpers
        extend ActiveSupport::Concern

        def params_to_methods
          (options.dig(:route_options, :params) || {}).each_key do |k|
            self.class.define_method(k) { params[k] }
          end
        end

        def success_model
          options.dig(:route_options, :success, :model)
        end
      end
    end
  end
end
