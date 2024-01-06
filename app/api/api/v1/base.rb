# frozen_string_literal: true

module API
  module V1
    class Base < API::Base
      include API::Exceptions::Handler
      include Helpers

      helpers GrapeHelpers, AuthHelpers

      use ActionDispatch::Session::CookieStore

      before do
        params_to_methods
        authenticate_with_token!
      end

      insert_before Grape::Middleware::Error, API::Middleware::Logger unless Rails.env.test?

      version 'v1', using: :path

      mount API::V1::Users

      route :any, '*path' do
        raise API::Exceptions::PageNotFound
      end
    end
  end
end
