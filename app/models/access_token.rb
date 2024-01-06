# frozen_string_literal: true

class AccessToken
  ALGORITHM = 'RS512'
  private_constant :ALGORITHM

  LIFETIME = 30.minutes
  private_constant :LIFETIME

  def self.decode(token)
    token = token.try(:[], :value) unless token.is_a?(String)
    key = OpenSSL::PKey::RSA.new(Rails.application.credentials.jwt_private_key!).public_key
    payload = JWT.decode(token, key, true, algorithm: ALGORITHM)
    new(token, payload)
  end

  def self.encode(payload)
    key = OpenSSL::PKey::RSA.new(Rails.application.credentials.jwt_private_key!)
    token = JWT.encode(payload, key, ALGORITHM)
    new(token, payload)
  end

  attr_accessor :token, :payload

  def initialize(token, payload)
    @token = token
    @payload = payload
  end

  def to_cookie
    {
      value:     token,
      path:      '/',
      secure:    true,
      http_only: true,
      expires:   LIFETIME.from_now.utc
    }
  end
end
