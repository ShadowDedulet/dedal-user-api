# frozen_string_literal: true

module API
  module V1
    class Users < API::V1::Base
      resource :users do
        desc 'List users',
             success: { model: API::Entities::V1::Users::User, as: :data, message: 'Successfully fetched' },
             failure: [API::Exceptions::Unauthorized.to_swagger_response]
        params do
          optional :login,    type: String, desc: 'Login'
          optional :email,    type: String, desc: 'E-mail'
          optional :username, type: String, desc: 'Username'
        end
        get do
          present User.where(declared(params, include_missing: false)), with: success_model
        end

        desc 'Registrate user',
             success:   { model: API::Entities::V1::Users::User, as: :data, message: 'Successfully created' },
             skip_auth: true
        params do
          requires :login,    type: String, desc: 'Login'
          requires :email,    type: String, desc: 'E-mail'
          requires :username, type: String, desc: 'Username'
          requires :password, type: String, desc: 'Password'
        end
        post :register do
          present User.create(declared(params)), with: success_model
        end

        desc 'Sign in user',
             success:   { model: API::Entities::V1::Users::User, message: 'Successfully fetched' },
             failure:   [API::Exceptions::Unauthorized.to_swagger_response],
             skip_auth: true
        params do
          requires :login_or_email, type: String, desc: 'Login or e-mail'
          requires :password,       type: String, desc: 'Password'
        end
        post :sign_in do
          filter_key = login_or_email.match?(Devise.email_regexp) ? :email : :login
          user = User.find_by(filter_key => login_or_email)
          raise(API::Exceptions::Unauthorized) unless user&.valid_password?(password)

          generate_and_save_tokens!(user:)
          present current_user, with: success_model
        end

        desc 'Refresh user`s session',
             success:   { model: API::Entities::V1::Users::User, as: :data, message: 'Successfully fetched' },
             failure:   [API::Exceptions::Unauthorized.to_swagger_response],
             skip_auth: true
        post :refresh do
          user = User.find_by(refresh_token:)
          raise(API::Exceptions::Unauthorized) if user.blank?

          generate_and_save_tokens!(user:)
          present current_user, with: success_model
        end

        desc 'Sign out user',
             success: { model: API::Entities::V1::Success, message: 'Successfully fetched' },
             failure: [API::Exceptions::Unauthorized.to_swagger_response]
        post :sign_out do
          clear_cookies
          current_user.sign_out!
          present success_model.default, with: success_model
        end
      end

      private

      helpers do
        def generate_and_save_tokens!(user:)
          save_access_token(AccessToken.encode(user.to_jwt_payload))
          save_refresh_token(RefreshToken.generate_for!(user))
        end
      end
    end
  end
end
