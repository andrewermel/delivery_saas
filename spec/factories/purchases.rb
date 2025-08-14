# spec/factories/purchases.rb
FactoryBot.define do
  factory :purchase do
    item_name { "Item Purchase" }
    price { 20.0 }
    weight { 5.0 }
    association :company
    association :item
  end
end
