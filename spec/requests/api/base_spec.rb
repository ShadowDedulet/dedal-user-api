# frozen_string_literal: true

RSpec.describe 'API::Base' do
  describe 'GET /ping' do
    it 'pongs' do
      get '/api/ping'
      expect(json_response).to(eq('pong'))
    end
  end
end
