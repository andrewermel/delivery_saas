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

  # Calcula o preço médio ponderado baseado nas compras
  # O price é o preço TOTAL da nota, não unitário
  def average_weighted_price
    return 0 if purchases.empty?
    total_cost = purchases.sum(:price).to_f  # Soma o preço total de todas as notas
    total_quantity = purchases.sum(:quantity).to_f  # Soma a quantidade total
    total_quantity.zero? ? 0 : (total_cost / total_quantity).round(2)
  end

  # Retorna estoque disponível (nunca negativo)
  def available_stock
    [quantity_in_stock, 0].max
  end

  # Calcula total investido em compras
  def total_invested
    purchases.sum(:price)
  end

  # Calcula total vendido
  def total_sold
    sales.sum(:total_price)
  end

  # Calcula margem de lucro
  def profit_margin
    total_sold - total_invested
  end
end
