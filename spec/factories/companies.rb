FactoryBot.define do
  factory :company do
    sequence(:name) { |n| "Company #{n}" }
    sequence(:cnpj_id) { |n| format("%014d", n) }
  end
end
