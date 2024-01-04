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

  create_table 'users', comment: 'Пользователи', force: :cascade do |t|
    t.string 'login', null: false, comment: 'Логин'
    t.string 'username', null: false, comment: 'Имя пользователя'
    t.string 'email', default: '', null: false, comment: 'Почта'
    t.string 'encrypted_password', default: '', null: false, comment: 'Зашифрованный пароль'
    t.string 'reset_password_token', comment: 'Токен восстановления пароля'
    t.datetime 'reset_password_sent_at', comment: 'Дата и время отправки токена восстановления'
    t.integer 'sign_in_count', default: 0, null: false, comment: 'Кол-во входов в систему'
    t.datetime 'current_sign_in_at', comment: 'Дата и время текущего входа в систему'
    t.datetime 'last_sign_in_at', comment: 'Дата и время последнего входа в систему'
    t.string 'current_sign_in_ip', comment: 'IP-адрес текущего входа в систему'
    t.string 'last_sign_in_ip', comment: 'IP-адрес последнего входа в систему'
    t.integer 'failed_attempts', default: 0, null: false, comment: 'Кол-во неудачных попыток входа в систему'
    t.string 'unlock_token', comment: 'Токен разблокировки УЗ'
    t.datetime 'locked_at', comment: 'Дата и время блокировки'
    t.datetime 'created_at', null: false, comment: 'Временные метки'
    t.datetime 'updated_at', null: false, comment: 'Временные метки'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
    t.index ['unlock_token'], name: 'index_users_on_unlock_token', unique: true
    t.index ['username'], name: 'index_users_on_username'
  end
end
