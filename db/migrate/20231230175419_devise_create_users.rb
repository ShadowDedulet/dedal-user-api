# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, comment: 'Пользователи' do |t|
      ## Database authenticatable
      t.string :login,              null: false, comment: 'Логин'
      t.string :username,           null: false, comment: 'Имя пользователя'
      t.string :email,              null: false, default: '', comment: 'Почта'

      t.string :encrypted_password, null: false, default: '', comment: 'Зашифрованный пароль'

      ## Recoverable
      t.string   :reset_password_token,   comment: 'Токен восстановления пароля'
      t.datetime :reset_password_sent_at, comment: 'Дата и время отправки токена восстановления'

      ## Rememberable
      # t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false, comment: 'Кол-во входов в систему'
      t.datetime :current_sign_in_at,                     comment: 'Дата и время текущего входа в систему'
      t.datetime :last_sign_in_at,                        comment: 'Дата и время последнего входа в систему'
      t.string   :current_sign_in_ip,                     comment: 'IP-адрес текущего входа в систему'
      t.string   :last_sign_in_ip,                        comment: 'IP-адрес последнего входа в систему'

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # Only if lock strategy is :failed_attempts
      t.integer  :failed_attempts, default: 0, null: false, comment: 'Кол-во неудачных попыток входа в систему'
      # Only if unlock strategy is :email or :both
      t.string   :unlock_token,                             comment: 'Токен разблокировки УЗ'
      t.datetime :locked_at,                                comment: 'Дата и время блокировки'

      t.timestamps null: false,                             comment: 'Временные метки'
    end

    add_index :users, :username
    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true
  end
end
