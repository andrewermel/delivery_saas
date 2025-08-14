# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    name { "Test User" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    association :company
    role { 0 } # ajuste conforme sua enum de roles no User
  end
end
