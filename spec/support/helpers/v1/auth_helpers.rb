# frozen_string_literal: true

module Helpers
  module V1
    module AuthHelpers
      include ::API::V1::Helpers::AuthHelpers

      def sign_in(user)
        save_access_token(AccessToken.encode(user.to_jwt_payload))
        save_refresh_token(RefreshToken.generate_for!(user))
      end

      def save_access_token(access_token)
        cookies[COOKIES_KEYS[:jwt]] = access_token.to_cookie[:value]
      end

      def save_refresh_token(refresh_token)
        cookies[COOKIES_KEYS[:rt]] = refresh_token.to_cookie(version)[:value]
      end

      def version
        'v1'
      end
    end
  end
end
