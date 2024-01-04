# frozen_string_literal: true

FactoryBot.define do
  factory :expected_env, class: Hash do
    grape_request { association(:grape_request) }
    grape_endpoint { association(:grape_endpoint) }
    params { grape_request[:params] }
    headers { grape_request[:headers] }
    post_params { {} }
    rails_post_params { {} }
    other_env_params { {} }
    request_method { 'GET' }

    initialize_with do
      new.merge(
        Rack::REQUEST_METHOD                          => request_method,
        :PATH_INFO                                    => '/api',
        :'action_dispatch.request.request_parameters' => rails_post_params,
        :'rack.input'                                 => StringIO.new,
        Grape::Env::GRAPE_REQUEST                     => grape_request,
        Grape::Env::GRAPE_REQUEST_PARAMS              => params,
        Grape::Env::GRAPE_REQUEST_HEADERS             => headers,
        Grape::Env::RACK_REQUEST_FORM_HASH            => post_params,
        Grape::Env::API_ENDPOINT                      => grape_endpoint).merge(other_env_params)
    end

    trait :post do
      request_method { 'POST' }
    end

    trait :prefixed_basic_headers do
      other_env_params do
        {
          HTTP_VERSION:         'HTTP/1.1',
          HTTP_CACHE_CONTROL:   'max-age=0',
          HTTP_USER_AGENT:      'Mozilla/5.0',
          HTTP_ACCEPT_LANGUAGE: 'en-US'
        }
      end
    end
  end

  factory :grape_endpoint, class: 'Grape::Endpoint' do
    settings { Grape::Util::InheritableSetting.new }
    options do
      {
        path:   [:v1],
        method: 'get',
        for:    API::V1
      }
    end

    initialize_with { new(settings, options) }

    trait :complex do
      options do
        {
          path:   [:v1],
          method: 'put',
          for:    API::V1
        }
      end
    end
  end

  factory :grape_request, class: Hash do
    headers { {} }

    initialize_with do
      new(request_method: 'POST', path: '/api', headers:, params: { id: '101001' })
    end

    trait :basic_headers do
      headers do
        {
          Version:           'HTTP/1.1',
          'Cache-Control':   'max-age=0',
          'User-Agent':      'Mozilla/5.0',
          'Accept-Language': 'en-US'
        }
      end
    end
  end
end
