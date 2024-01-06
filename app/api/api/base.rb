# frozen_string_literal: true

module API
  class Base < Grape::API
    format :json

    desc 'Ping', success: { message: 'Successfully fetched' }, skip_auth: true
    get :ping do
      :pong
    end

    mount API::V1::Base

    add_swagger_documentation \
      info:             {
        title:       'MUCAS: User API',
        description: 'API for managing users and their sessions',
        skip_auth:   'Accessible without authorization'
      },
      array_use_braces: true,
      produces:         ['application/json']
  end
end
