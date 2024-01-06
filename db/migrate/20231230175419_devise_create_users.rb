# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, comment: 'Users' do |t|
      ## Database authenticatable
      t.string :login,              null: false, comment: 'Login'
      t.string :username,           null: false, comment: 'Username'
      t.string :email,              null: false, default: '', comment: 'E-mail'

      t.string :encrypted_password, null: false, default: '', comment: 'Encrypted password'

      ## Recoverable
      t.string   :reset_password_token,   comment: 'Reset password token'
      t.datetime :reset_password_sent_at, comment: 'Date and time reset password token was sent'

      ## Rememberable
      # t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false, comment: 'Sign in count'
      t.datetime :current_sign_in_at,                     comment: 'Date and time signing in current session'
      t.datetime :last_sign_in_at,                        comment: 'Date and time signing in last session'
      t.string   :current_sign_in_ip,                     comment: 'IP-address signing in current session'
      t.string   :last_sign_in_ip,                        comment: 'IP-address signing in last session'

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # Only if lock strategy is :failed_attempts
      t.integer  :failed_attempts, default: 0, null: false, comment: 'Amount of failed attempts'
      # Only if unlock strategy is :email or :both
      t.string   :unlock_token,                             comment: 'Unlock token'
      t.datetime :locked_at,                                comment: 'Block date and time'

      t.timestamps null: false,                             comment: 'Timestamps'
    end

    add_index :users, :username
    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true
  end
end
