class Inventory < ApplicationRecord
  belongs_to :item
  belongs_to :company
  belongs_to :purchase, optional: true
  belongs_to :sale, optional: true

  validates :quantity_change, presence: true, numericality: { only_integer: true }
  validates :movement_type, presence: true, inclusion: { in: %w(purchase sale) }

  # Escopos úteis
  scope :purchases, -> { where(movement_type: 'purchase') }
  scope :sales, -> { where(movement_type: 'sale') }
  scope :by_company, ->(company) { where(company: company) }
  scope :by_item, ->(item) { where(item: item) }
  scope :recent, -> { order(created_at: :desc) }
end
