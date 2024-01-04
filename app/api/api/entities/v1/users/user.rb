# frozen_string_literal: true

module API
  module Entities
    module V1
      module Users
        class User < Base
          expose :id,         documentation: { type: Integer, desc: 'Идентификатор'    }
          expose :login,      documentation: { type: String,  desc: 'Логин'            }
          expose :email,      documentation: { type: String,  desc: 'Почта'            }
          expose :username,   documentation: { type: String,  desc: 'Имя пользователя' }

          expose :created_at, date_time(documentation: { desc: 'Дата и время создания'              })
          expose :updated_at, date_time(documentation: { desc: 'Дата и время последнего обновления' })
        end
      end
    end
  end
end
