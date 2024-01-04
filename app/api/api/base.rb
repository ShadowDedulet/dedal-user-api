# frozen_string_literal: true

module API
  class Base < Grape::API
    mount API::V1::Base

    add_swagger_documentation \
      info:             {
        title:       'Адаптер МЭДО',
        description: 'API-Сервис для интеграции с МЭДО. Содержит данные с нескольких ФО.',
        skip_auth:   'Доступ к ресурсу без авторизации'
      },
      array_use_braces: true,
      produces:         ['application/json']
  end
end
