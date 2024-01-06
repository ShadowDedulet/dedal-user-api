# frozen_string_literal: true

class AddRefreshTokenToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :refresh_token, :string, comment: 'Refresh token'
    add_index :users, %i[refresh_token], unique: true
  end
end
