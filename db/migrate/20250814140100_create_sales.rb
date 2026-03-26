class CreateSales < ActiveRecord::Migration[8.0]
  def change
    create_table :sales do |t|
      t.references :item, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.decimal :unit_price, precision: 10, scale: 2, null: false
      t.decimal :total_price, precision: 10, scale: 2, null: false
      t.date :sale_date, null: false

      t.timestamps
    end

    add_index :sales, [:company_id, :created_at], name: 'index_sales_on_company_and_created_at'
  end
end
