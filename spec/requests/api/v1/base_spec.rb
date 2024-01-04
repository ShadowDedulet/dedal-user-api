# frozen_string_literal: true

RSpec.describe 'API::V1::Base' do
  it 'handles 404' do
    get '/api/v1/not_found'
    expect(response_error).to(eq({ title: API::Exceptions::PageNotFound::MESSAGE }))
  end
end
