# frozen_string_literal: true

module API
  module V1
    module Helpers
      module AuthHelpers
        extend ActiveSupport::Concern

        COOKIES_KEYS = { jwt: 'dedal_access', rt: 'dedal_refresh' }.freeze
        private_constant :COOKIES_KEYS

        def authenticate_with_token!
          return if skip_authentication?

          current_user
        rescue OpenSSL::PKey::PKeyError, ActiveRecord::RecordNotFound
          raise(API::Exceptions::Unauthorized)
        end

        def skip_authentication?
          options[:route_options][:skip_auth].present?
        end

        def current_user
          raise(API::Exceptions::Unauthorized) if access_token.blank?

          @current_user ||= begin
            token = AccessToken.decode(access_token)
            user_id = token.payload.first['id']
            User.find(user_id)
          end
        end

        def access_token
          cookies[COOKIES_KEYS[:jwt]]
        end

        def refresh_token
          cookies[COOKIES_KEYS[:rt]]
        end

        def save_access_token(access_token)
          cookies[COOKIES_KEYS[:jwt]] = access_token.to_cookie
        end

        def save_refresh_token(refresh_token)
          cookies[COOKIES_KEYS[:rt]] = refresh_token.to_cookie(version)
        end

        def clear_cookies
          cookies.delete(COOKIES_KEYS[:jwt])
          cookies.delete(COOKIES_KEYS[:rt])
        end
      end
    end
  end
end
