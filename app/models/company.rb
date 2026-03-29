class Company < ApplicationRecord
  has_many :users
  has_many :items, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :sales, dependent: :destroy
  has_many :inventories, dependent: :destroy
  has_many :portions
  has_many :products

  validates :name, presence: true
  validates :cnpj_id, presence: true, uniqueness: true

  # Calcula total investido
  def total_invested
    purchases.sum(:price)
  end

  # Calcula total em receita
  def total_revenue
    sales.sum(:total_price)
  end

  # Calcula lucro líquido
  def net_profit
    total_revenue - total_invested
  end
end
