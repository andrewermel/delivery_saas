json.extract! purchase, :id, :item_name, :item_id, :price, :weight, :company_id, :created_at, :updated_at
json.url purchase_url(purchase, format: :json)
