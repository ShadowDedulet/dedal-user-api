# frozen_string_literal: true

RSpec.describe 'API::V1::Base' do
  let!(:current_user) { create(:user) }

  after { current_user.destroy }

  it 'pings' do
    get '/api/v1'
    expect(json_response).to(eq(API::Entities::V1::Success.default.deep_symbolize_keys))
  end

  context 'when authenticated' do
    before { sign_in(current_user) }

    it 'handlers PageNotFound' do
      get '/api/v1/not_found'
      expect(response).to(have_http_status(:not_found))
      expect(response_error).to(have_key(:title))
    end

    it 'handles StandardError' do
      allow(User).to(receive(:where).and_raise(StandardError))
      get '/api/v1/users'
      expect(response).to(have_http_status(:internal_server_error))
      expect(response_error).to(have_key(:title))
    end

    it 'handles NotImplementedError' do
      allow(User).to(receive(:where).and_raise(NotImplementedError))
      get '/api/v1/users'
      expect(response).to(have_http_status(:not_implemented))
      expect(response_error).to(have_key(:title))
    end
  end
end
