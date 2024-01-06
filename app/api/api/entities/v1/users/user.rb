# frozen_string_literal: true

module API
  module Entities
    module V1
      module Users
        class User < Base
          expose :id,         documentation: { type: Integer, desc: 'Identifier' }
          expose :login,      documentation: { type: String,  desc: 'Login'      }
          expose :email,      documentation: { type: String,  desc: 'E-mail'     }
          expose :username,   documentation: { type: String,  desc: 'Username'   }

          expose :created_at, date_time(documentation: { desc: 'Creation Date and time'    })
          expose :updated_at, date_time(documentation: { desc: 'Last update Date and time' })
        end
      end
    end
  end
end
