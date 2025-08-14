# spec/factories/items.rb
FactoryBot.define do
  factory :item do
    name { "Item A" }
    weight { 1.5 }
    price { 10.0 }
    association :company
  end
end
