class AddQuantityInStockToItems < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :quantity_in_stock, :integer, default: 0, null: false
  end
end
