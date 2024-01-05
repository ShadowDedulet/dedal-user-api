# frozen_string_literal: true

module API
  module V1
    class Users < API::V1::Base
      resource :users do
        desc 'Список пользователей',
             success: { model: API::Entities::V1::Users::User, as: :data, message: 'Successfully fetched' },
             failure: [API::Exceptions::Unauthorized.to_swagger_response]
        params do
          optional :login,    type: String, desc: 'Логин'
          optional :email,    type: String, desc: 'Почта'
          optional :username, type: String, desc: 'Имя пользователя'
        end
        get do
          present User.where(declared(params, include_missing: false)), with: success_model
        end

        desc 'Регистрация пользователя',
             success:   { model: API::Entities::V1::Users::User, as: :data, message: 'Successfully created' },
             skip_auth: true
        params do
          requires :login,    type: String, desc: 'Логин'
          requires :email,    type: String, desc: 'Почта'
          requires :username, type: String, desc: 'Имя пользователя'
          requires :password, type: String, desc: 'Пароль'
        end
        post :register do
          present User.create(declared(params)), with: success_model
        end

        desc 'Вход пользователя в систему',
             success:   { model: API::Entities::V1::Users::User, message: 'Successfully fetched' },
             failure:   [API::Exceptions::Unauthorized.to_swagger_response],
             skip_auth: true
        params do
          requires :login_or_email, type: String, desc: 'Логин или почта'
          requires :password,       type: String, desc: 'Пароль'
        end
        post :sign_in do
          filter_key = login_or_email.match?(Devise.email_regexp) ? :email : :login
          user = User.find_by(filter_key => login_or_email)
          raise(API::Exceptions::Unauthorized) unless user&.valid_password?(password)

          save_tokens(user:)
          present current_user, with: success_model
        end

        desc 'Обновление сессии пользователя',
             success:   { model: API::Entities::V1::Users::User, as: :data, message: 'Successfully fetched' },
             failure:   [API::Exceptions::Unauthorized.to_swagger_response],
             skip_auth: true
        post :refresh do
          user = User.find_by(refresh_token:)
          raise(API::Exceptions::Unauthorized) if user.blank?

          save_tokens(user:)
          present current_user, with: success_model
        end
      end

      private

      helpers do
        def save_tokens(user:)
          save_access_token(AccessToken.encode(user.to_jwt_payload))
          save_refresh_token(RefreshToken.generate_for!(user))
        end
      end
    end
  end
end
