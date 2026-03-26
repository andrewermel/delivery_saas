class CreateInventories < ActiveRecord::Migration[8.0]
  def change
    create_table :inventories do |t|
      t.references :item, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.integer :quantity_change, null: false, comment: "Positivo para entrada (compra), negativo para saída (venda)"
      t.string :movement_type, null: false, comment: "purchase ou sale"
      t.references :purchase, null: true, foreign_key: true
      t.references :sale, null: true, foreign_key: true
      t.text :notes

      t.timestamps
    end

    add_index :inventories, [:item_id, :created_at], name: 'index_inventories_on_item_and_created_at'
    add_index :inventories, :movement_type
  end
end
