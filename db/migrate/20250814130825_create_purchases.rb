class CreatePurchases < ActiveRecord::Migration[8.0]
  def change
    create_table :purchases do |t|
      t.string :item_name
      t.integer :item_id
      t.decimal :price
      t.decimal :weight
      t.integer :company_id

      t.timestamps
    end
  end
end
