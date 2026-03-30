class Sale < ApplicationRecord
  belongs_to :item
  belongs_to :company
  has_one :inventory, dependent: :destroy

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :sale_date, presence: true
  validate :item_must_belong_to_company
  validate :sufficient_stock_on_create, on: :create
  validate :sufficient_stock_on_update, on: :update

  before_create :set_total_price
  before_update :store_old_values
  after_commit :sync_inventory_create, on: :create
  after_commit :sync_inventory_update, on: :update
  after_commit :sync_inventory_destroy, on: :destroy

  private

  def item_must_belong_to_company
    return unless item.present?
    errors.add(:item, "must belong to the same company") if item.company_id != company_id
  end

  def sufficient_stock_on_create
    return unless item.present?
    item.with_lock do
      errors.add(:quantity, "Insufficient stock. Available: #{item.quantity_in_stock}") if item.quantity_in_stock < quantity.to_i
    end
  end

  def sufficient_stock_on_update
    return unless item.present?
    quantity_diff = quantity.to_i - @old_quantity.to_i
    return if quantity_diff <= 0

    item.with_lock do
      errors.add(:quantity, "Insufficient stock to increase. Available: #{item.quantity_in_stock}") if item.quantity_in_stock < quantity_diff
    end
  end

  def set_total_price
    self.total_price = (unit_price.to_f * quantity.to_f).round(2)
  end

  def store_old_values
    @old_quantity = quantity_was
    @old_price = unit_price_was
  end

  def sync_inventory_create
    return unless item
    transaction do
      Inventory.create!(
        item: item,
        company: company,
        quantity_change: -quantity.to_i,
        movement_type: :sale,
        sale: self
      )
      item.with_lock { item.decrement!(:quantity_in_stock, quantity.to_i) }
    end
  end

  def sync_inventory_update
    return unless item
    quantity_diff = quantity.to_i - @old_quantity.to_i
    return if quantity_diff.zero?

    transaction do
      inventory&.update!(quantity_change: -quantity.to_i)
      item.with_lock do
        if quantity_diff > 0
          item.decrement!(:quantity_in_stock, quantity_diff)
        else
          item.increment!(:quantity_in_stock, quantity_diff.abs)
        end
      end
    end
  end

  def sync_inventory_destroy
    return unless item
    item.with_lock { item.increment!(:quantity_in_stock, quantity.to_i) }
  end
end

