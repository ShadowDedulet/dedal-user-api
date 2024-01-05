# frozen_string_literal: true

class RefreshToken
  RT_LENGTH = 1024
  private_constant :RT_LENGTH

  LIFETIME = 1.week
  private_constant :LIFETIME

  def self.generate_for!(user)
    new(user)
  end

  attr_accessor :user, :token

  def initialize(user)
    @user = user
    generate!
  end

  def to_cookie(api_version)
    {
      value:     token,
      path:      "/api/#{api_version}/users/refresh",
      secure:    true,
      http_only: true,
      expires:   LIFETIME.from_now.utc
    }
  end

  def generate!
    @token = SecureRandom.base64(RT_LENGTH)
    user.refresh_token = token
    user.save!
  end
end
