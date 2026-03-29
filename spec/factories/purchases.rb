# spec/factories/purchases.rb
FactoryBot.define do
  factory :purchase do
    item_name { "Item Purchase" }
    price { 20.0 }
    quantity { 1 }
    association :company
    association :item
  end
end
