# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'User' do
    login    { user[:username]  }
    username { user[:user_name] }
    email    { user[:email]     }
    password { user[:password]  }

    transient do
      user { Faker::Internet.user(:username, :user_name, :email, :password) }
    end
  end
end
