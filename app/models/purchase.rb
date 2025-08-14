class Purchase < ApplicationRecord
  belongs_to :company
  belongs_to :item, optional: true

  validates :item_name, presence: true
  validates :weight, presence: true
  validates :price, presence: true

end
