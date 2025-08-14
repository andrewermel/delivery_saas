class AddForeignKeyToPurchases < ActiveRecord::Migration[8.0]
  def change
    # Primeiro, garantimos que item_id seja bigint como a tabela items
    change_column :purchases, :item_id, :bigint

    # Adicionamos a foreign key
    add_foreign_key :purchases, :items

    # Adicionamos um índice para melhor performance
    add_index :purchases, :item_id
  end
end
