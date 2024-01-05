# frozen_string_literal: true

class User < ApplicationRecord
  ACCESS_PAYLOAD_DENYLIST = %i[refresh_token].freeze
  private_constant :ACCESS_PAYLOAD_DENYLIST

  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         # :rememberable,
         :validatable,
         :trackable,
         # :confirmable,
         :lockable

  def to_jwt_payload
    as_json(except: ACCESS_PAYLOAD_DENYLIST)
  end
end
