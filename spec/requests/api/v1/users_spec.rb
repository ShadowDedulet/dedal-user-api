# frozen_string_literal: true

RSpec.describe 'API::V1::Users' do
  let(:url) { proc { |endpoint| "/api/v1/users#{endpoint}" } }

  let!(:current_user) { create(:user) }

  let(:new_user_attrs)  { attributes_for(:user) }
  let(:user_attrs_keys) { new_user_attrs.keys   }

  describe 'POST /register' do
    it 'creates user' do
      expect { post url.call('/register'), params: new_user_attrs }
        .to(change(User, :count)
        .by(1))
    ensure
      filter = new_user_attrs.slice(*User.column_names.map(&:to_sym))
      User.find_by(filter)&.destroy!
    end
  end

  context 'when authenticated' do
    before { sign_in(current_user) }

    describe 'GET /' do
      let!(:users) { create_list(:user, 3) }

      after { users.each(&:destroy) }

      it 'returns :unauthorized if user was deleted' do
        allow(User).to(receive(:find).and_raise(ActiveRecord::RecordNotFound))
        get url.call
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns all users' do
        get url.call
        all_users = [current_user] + users
        expected = all_users.map { |usr| factory_to_entity(usr, API::Entities::V1::Users::User) }
        expect(response_data).to(eq(expected))
      end

      it 'returns filtered user' do
        user = users.sample
        filter_key = user_attrs_keys.sample
        get url.call, params: { filter_key => user[filter_key] }

        expected = factory_to_entity(user, API::Entities::V1::Users::User)
        expect(response_data).to(eq([expected]))
      end
    end

    describe 'POST /refresh' do
      it 'returns :unauthorized with wrong token' do
        RefreshToken.generate_for!(current_user)

        post url.call('/refresh')
        expect(response).to(have_http_status(:unauthorized))
      end

      it 'refreshes cookies' do
        post url.call('/refresh')
        expect(response.cookies).not_to(eq(cookies))
      end
    end
  end

  context 'when not authenticated' do
    describe 'GET /' do
      it 'returns :unauthorized' do
        get url.call
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'POST /sign_in' do
      it 'returns :unauthorized with wrong login or email' do
        post url.call('/sign_in'),
             params: { login_or_email: "#{current_user.login}_test", password: current_user.password }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns :unauthorized with wrong password' do
        post url.call('/sign_in'),
             params: { login_or_email: current_user.login, password: "#{current_user.password}_test" }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'authorizes by email' do
        post url.call('/sign_in'), params: { login_or_email: current_user.email, password: current_user.password }
        expect(response.cookies.keys).to(include(*API::V1::Helpers::AuthHelpers.const_get(:COOKIES_KEYS).values))
      end

      it 'authorizes by login' do
        post url.call('/sign_in'), params: { login_or_email: current_user.login, password: current_user.password }
        expect(response.cookies.keys).to(include(*API::V1::Helpers::AuthHelpers.const_get(:COOKIES_KEYS).values))
      end
    end
  end
end
