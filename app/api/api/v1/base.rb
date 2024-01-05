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
      format :json

      mount API::V1::Users

      desc 'Ping', success: { model: API::Entities::V1::Success, message: 'Successfully fetched' }, skip_auth: true
      get do
        present success_model.default, with: success_model
      end

      route :any, '*path' do
        raise API::Exceptions::PageNotFound
      end
    end
  end
end
