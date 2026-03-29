FactoryBot.define do
  factory :inventory do
    company
    item
    quantity_change { 1 }
    movement_type { "purchase" }
  end
end
