class Item < ApplicationRecord
  belongs_to :company
  has_many :purchases, dependent: :destroy
  has_many :sales, dependent: :destroy
  has_many :inventories, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :company_id }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :company_id, presence: true
  validates :weight, presence: true
  validates :quantity_in_stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :in_stock, -> { where(quantity_in_stock: 1..) }

  def average_weighted_price
    return 0 if purchases.empty?
    total_cost = purchases.sum(:price).to_f
    total_quantity = purchases.sum(:quantity).to_f
    total_quantity.zero? ? 0 : (total_cost / total_quantity).round(2)
  end

  def total_invested
    purchases.sum(:price)
  end

  def total_sold
    sales.sum(:total_price)
  end

  def profit_margin
    total_sold - total_invested
  end
end
