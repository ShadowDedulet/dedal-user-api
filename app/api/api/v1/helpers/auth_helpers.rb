# frozen_string_literal: true

module API
  module V1
    module Helpers
      module AuthHelpers
        extend ActiveSupport::Concern

        ALGORITHM = 'RS512'
        public_constant :ALGORITHM

        def authenticate_with_token!
          return if skip_authentication?

          raise(API::Exceptions::Unauthorized) if current_user.blank?
        end

        def skip_authentication?
          options[:route_options][:skip_auth].present?
        end

        def current_user
          @current_user ||= begin
            key = OpenSSL::PKey::RSA.new(Rails.application.credentials.devise_jwt_private_key!).public_key
            user_data = JWT.decode(token, key, true, algorithm: ALGORITHM).first['user']
            User.find(user_data['id'])
          end
        rescue OpenSSL::PKey::PKeyError, ActiveRecord::RecordNotFound
          raise(API::Exceptions::Unauthorized)
        end

        def token
          params[:token] || cookies[auth_token_cookie_key]
          # auth = headers['Authorization'].to_s
          # auth.split.last
        end

        def auth_token_cookie_key
          'resume_token'
        end

        def user_to_jwt(user = current_user)
          key = OpenSSL::PKey::RSA.new(Rails.application.credentials.devise_jwt_private_key!)
          JWT.encode(jwt_payload(user), key, ALGORITHM)
        end

        def jwt_payload(user)
          user.as_json
        end
      end
    end
  end
end
