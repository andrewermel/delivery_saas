class Sale < ApplicationRecord
  belongs_to :item
  belongs_to :company
  has_one :inventory, dependent: :destroy

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :sale_date, presence: true

  before_create :set_total_price, :validate_and_update_inventory
  after_create :create_inventory_record
  after_destroy :restore_inventory

  private

  def set_total_price
    self.total_price = (unit_price.to_f * quantity.to_f).round(2)
  end

  def validate_and_update_inventory
    # Valida se há estoque suficiente
    if item.available_stock < quantity
      errors.add(:quantity, "Estoque insuficiente. Disponível: #{item.available_stock}")
      throw(:abort)
    end
  end

  def create_inventory_record
    # Cria registro de saída de estoque
    Inventory.create!(
      item: item,
      company: company,
      quantity_change: -quantity.to_i,
      movement_type: 'sale',
      sale: self,
      notes: "Venda de #{quantity}un a R$#{unit_price}"
    )

    # Atualiza estoque
    item.decrement!(:quantity_in_stock, quantity.to_i)
  end

  def restore_inventory
    # Restaura estoque ao deletar venda
    item.increment!(:quantity_in_stock, quantity.to_i)
    inventory&.destroy
  end
end
