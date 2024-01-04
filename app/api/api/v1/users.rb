# frozen_string_literal: true

module API
  module V1
    class Users < API::V1::Base
      resource :users do
        desc 'Список пользователей',
             success: { model: API::Entities::V1::Users::User, as: :data, message: 'Successfully fetched' }
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
        get :register do
          present User.create(declared(params)), with: success_model
        end

        desc 'Вход пользователя в систему',
             success:   { model: API::Entities::V1::Success, message: 'Successfully fetched' },
             skip_auth: true
        params do
          requires :login_or_email, type: String, desc: 'Логин или почта'
          requires :password,       type: String, desc: 'Пароль'
        end
        get :sign_in do
          filter = login_or_email.match?(Devise.email_regexp) ? { email: login_or_email } : { login: login_or_email }
          user = User.find_by(filter)

          raise(API::Exceptions::Unauthorized) unless user&.valid_password?(password)

          token = user_to_jwt(user:)
          cookies[auth_token_cookie_key] = {
            value:     token,
            path:      '/',
            secure:    true,
            http_only: true,
            expires:   30.minutes.from_now.utc
          }

          present success_model.default, with: success_model
        end
      end
    end
  end
end
