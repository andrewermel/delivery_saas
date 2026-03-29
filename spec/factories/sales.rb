FactoryBot.define do
  factory :sale do
    company
    item
    quantity { 1 }
    unit_price { 100.00 }
    sale_date { Date.today }
  end
end
