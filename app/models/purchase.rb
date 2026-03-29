class Purchase < ApplicationRecord
  belongs_to :company
  belongs_to :item, optional: true
  has_one :inventory, dependent: :destroy

  validates :item_name, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  after_create :handle_create
  after_create_commit :recalculate_item_price
  before_update :store_old_values
  after_update :handle_update
  after_update_commit :recalculate_price_after_update
  after_destroy :handle_destroy
  after_destroy_commit :recalculate_price_after_destroy

  private

  def store_old_values
    @old_quantity = quantity_was
    @old_price = price_was
  end

  # Executa ao criar uma nova compra
  def handle_create
    return unless item

    # Cria registro de entrada no inventário
    Inventory.create!(
      item: item,
      company: company,
      quantity_change: quantity.to_i,
      movement_type: 'purchase',
      purchase: self,
      notes: "Compra de #{quantity}un por R$#{price} (R$#{(price.to_f / quantity).round(2)}/un)"
    )

    # Aumenta o estoque
    item.increment!(:quantity_in_stock, quantity.to_i)
  end

  # Recalcula preço DEPOIS que a transação foi commitada
  def recalculate_item_price
    return unless item
    
    new_price = item.average_weighted_price
    item.update!(price: new_price)
    Rails.logger.info("[PURCHASE CREATE] Item #{item.id} updated: price=#{new_price}, stock=#{item.quantity_in_stock}")
  end

  # Executa ao atualizar uma compra existente
  def handle_update
    return unless item

    quantity_diff = quantity.to_i - @old_quantity.to_i

    if quantity_diff != 0
      # Atualiza Inventory record
      if inventory
        inventory.update(
          quantity_change: quantity.to_i,
          notes: "Compra ajustada: #{quantity.to_i}un a R$#{price} (era #{@old_quantity}un a R$#{@old_price})"
        )
      end

      # Ajusta estoque
      if quantity_diff > 0
        item.increment!(:quantity_in_stock, quantity_diff)
      else
        item.decrement!(:quantity_in_stock, quantity_diff.abs)
      end
    end
  end

  # Recalcula preço após update ser commitado
  def recalculate_price_after_update
    return unless item
    item.update!(price: item.average_weighted_price)
  end

  # Executa ao deletar uma compra
  def handle_destroy
    return unless item

    # Remove do estoque
    item.decrement!(:quantity_in_stock, quantity.to_i)

    # Inventory é deletado automaticamente pela dependência
  end

  # Recalcula preço após delete ser commitado
  def recalculate_price_after_destroy
    return unless item
    item.update!(price: item.average_weighted_price)
  end
end

