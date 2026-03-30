class Purchase < ApplicationRecord
  belongs_to :company
  belongs_to :item
  has_one :inventory, dependent: :destroy

  validates :item_name, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_update :store_old_values
  after_commit :sync_inventory_and_pricing, on: [:create, :update]
  after_commit :cleanup_inventory, on: :destroy

  private

  def store_old_values
    @old_quantity = quantity_was
    @old_price = price_was
  end

  def sync_inventory_and_pricing
    return unless item
    transaction do
      create_or_update_inventory_entry
      adjust_stock
      recalculate_weighted_price
    end
  end

  def create_or_update_inventory_entry
    if previous_changes.key?(:quantity) || new_record?
      Inventory.create!(
        item: item,
        company: company,
        quantity_change: quantity.to_i,
        movement_type: :purchase,
        purchase: self
      )
    elsif inventory && (previous_changes.key?(:quantity) || previous_changes.key?(:price))
      quantity_diff = quantity.to_i - @old_quantity.to_i
      inventory.update!(quantity_change: quantity.to_i)
    end
  end

  def adjust_stock
    if new_record?
      item.with_lock { item.increment!(:quantity_in_stock, quantity.to_i) }
    else
      quantity_diff = quantity.to_i - @old_quantity.to_i
      return if quantity_diff.zero?

      item.with_lock do
        quantity_diff > 0 ? item.increment!(:quantity_in_stock, quantity_diff) : item.decrement!(:quantity_in_stock, quantity_diff.abs)
      end
    end
  end

  def recalculate_weighted_price
    item.update_column(:price, item.average_weighted_price)
  end

  def cleanup_inventory
    return unless item
    item.with_lock { item.decrement!(:quantity_in_stock, quantity.to_i) }
  end
end

