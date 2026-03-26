class Sale < ApplicationRecord
  belongs_to :item
  belongs_to :company
  has_one :inventory, dependent: :destroy

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :sale_date, presence: true

  before_create :set_total_price_and_validate_stock
  before_update :store_old_values
  after_create :handle_create
  after_update :handle_update
  after_destroy :handle_destroy

  private

  def store_old_values
    @old_quantity = quantity_was
    @old_price = unit_price_was
  end

  def set_total_price_and_validate_stock
    self.total_price = (unit_price.to_f * quantity.to_f).round(2)
    
    # Valida se há estoque suficiente
    if item.quantity_in_stock < quantity.to_i
      errors.add(:quantity, "Estoque insuficiente. Disponível: #{item.quantity_in_stock}")
      throw(:abort)
    end
  end

  # Executa ao criar uma nova venda
  def handle_create
    return unless item

    # Cria registro de saída no inventário
    Inventory.create!(
      item: item,
      company: company,
      quantity_change: -quantity.to_i,
      movement_type: 'sale',
      sale: self,
      notes: "Venda de #{quantity}un a R$#{unit_price}"
    )

    # Diminui o estoque
    item.decrement!(:quantity_in_stock, quantity.to_i)
  end

  # Executa ao atualizar uma venda existente
  def handle_update
    return unless item

    quantity_diff = quantity.to_i - @old_quantity.to_i

    # Valida se há estoque para a mudança
    if quantity_diff > 0 && item.quantity_in_stock < quantity_diff
      errors.add(:quantity, "Estoque insuficiente para aumentar. Disponível: #{item.quantity_in_stock}")
      raise "Abortando atualização"
    end

    if quantity_diff != 0
      # Atualiza Inventory record
      if inventory
        inventory.update(
          quantity_change: -quantity.to_i,
          notes: "Venda ajustada: #{quantity}un a R$#{unit_price} (era #{@old_quantity}un a R$#{@old_price})"
        )
      end

      # Ajusta estoque
      if quantity_diff > 0
        item.decrement!(:quantity_in_stock, quantity_diff)
      else
        item.increment!(:quantity_in_stock, quantity_diff.abs)
      end
    end

    # Atualiza total_price se quantidade ou preço mudou
    self.update_column(:total_price, (unit_price.to_f * quantity.to_f).round(2)) if quantity_changed? || unit_price_changed?
  end

  # Executa ao deletar uma venda
  def handle_destroy
    return unless item

    # Restaura o estoque
    item.increment!(:quantity_in_stock, quantity.to_i)

    # Inventory é deletado automaticamente pela dependência
  end
end

