# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_03_29_153443) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "cnpj_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventories", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "company_id", null: false
    t.integer "quantity_change", null: false, comment: "Positivo para entrada (compra), negativo para saída (venda)"
    t.string "movement_type", null: false, comment: "purchase ou sale"
    t.bigint "purchase_id"
    t.bigint "sale_id"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_inventories_on_company_id"
    t.index ["item_id", "created_at"], name: "index_inventories_on_item_and_created_at"
    t.index ["item_id"], name: "index_inventories_on_item_id"
    t.index ["movement_type"], name: "index_inventories_on_movement_type"
    t.index ["purchase_id"], name: "index_inventories_on_purchase_id"
    t.index ["sale_id"], name: "index_inventories_on_sale_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.decimal "weight"
    t.decimal "price"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity_in_stock", default: 0, null: false
    t.index ["company_id"], name: "index_items_on_company_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.string "item_name"
    t.bigint "item_id"
    t.decimal "price"
    t.decimal "quantity"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_purchases_on_item_id"
  end

  create_table "sales", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "company_id", null: false
    t.integer "quantity", null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.decimal "total_price", precision: 10, scale: 2, null: false
    t.date "sale_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "created_at"], name: "index_sales_on_company_and_created_at"
    t.index ["company_id"], name: "index_sales_on_company_id"
    t.index ["item_id"], name: "index_sales_on_item_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "role"
    t.bigint "company_id"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "inventories", "companies"
  add_foreign_key "inventories", "items"
  add_foreign_key "inventories", "purchases"
  add_foreign_key "inventories", "sales"
  add_foreign_key "items", "companies"
  add_foreign_key "purchases", "companies"
  add_foreign_key "purchases", "items"
  add_foreign_key "sales", "companies"
  add_foreign_key "sales", "items"
  add_foreign_key "users", "companies"
end
