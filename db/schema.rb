# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_240_104_095_753) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'users', comment: 'Users', force: :cascade do |t|
    t.string 'login', null: false, comment: 'Login'
    t.string 'username', null: false, comment: 'Username'
    t.string 'email', default: '', null: false, comment: 'E-mail'
    t.string 'encrypted_password', default: '', null: false, comment: 'Encrypted password'
    t.string 'reset_password_token', comment: 'Reset password token'
    t.datetime 'reset_password_sent_at', comment: 'Date and time reset password token was sent'
    t.integer 'sign_in_count', default: 0, null: false, comment: 'Sign in count'
    t.datetime 'current_sign_in_at', comment: 'Date and time signing in current session'
    t.datetime 'last_sign_in_at', comment: 'Date and time signing in last session'
    t.string 'current_sign_in_ip', comment: 'IP-address signing in current session'
    t.string 'last_sign_in_ip', comment: 'IP-address signing in last session'
    t.integer 'failed_attempts', default: 0, null: false, comment: 'Amount of failed attempts'
    t.string 'unlock_token', comment: 'Unlock token'
    t.datetime 'locked_at', comment: 'Block date and time'
    t.datetime 'created_at', null: false, comment: 'Timestamps'
    t.datetime 'updated_at', null: false, comment: 'Timestamps'
    t.string 'refresh_token', comment: 'Refresh token'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['refresh_token'], name: 'index_users_on_refresh_token', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
    t.index ['unlock_token'], name: 'index_users_on_unlock_token', unique: true
    t.index ['username'], name: 'index_users_on_username'
  end
end
