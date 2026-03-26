class RenameWeightToQuantityInPurchases < ActiveRecord::Migration[8.0]
  def change
    rename_column :purchases, :weight, :quantity
  end
end
