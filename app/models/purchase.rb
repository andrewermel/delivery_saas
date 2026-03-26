class Purchase < ApplicationRecord
  belongs_to :company
  belongs_to :item, optional: true
  has_one :inventory, dependent: :destroy

  validates :item_name, presence: true
  validates :weight, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  after_create :update_item_price_and_inventory
  after_update :update_item_price_and_inventory
  after_destroy :remove_from_inventory

  private

  def update_item_price_and_inventory
    # Atualiza o preço médio do item
    item.update(price: item.average_weighted_price) if item

    # Cria entrada de inventário (entrada de compra)
    Inventory.create(
      item: item,
      company: company,
      quantity_change: weight.to_i,
      movement_type: 'purchase',
      purchase: self,
      notes: "Compra de #{weight}un a R$#{price}"
    ) if item

    # Atualiza quantidade em estoque
    item.increment!(:quantity_in_stock, weight.to_i) if item
  end

  def remove_from_inventory
    # Remove do estoque ao deletar compra
    item.decrement!(:quantity_in_stock, weight.to_i) if item && quantity_in_stock > 0
    inventory&.destroy
  end
end
