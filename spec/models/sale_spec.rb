require "rails_helper"

RSpec.describe Sale, type: :model do
  let(:company) { create(:company) }
  let(:item) { create(:item, company: company, quantity_in_stock: 100) }

  it "creates a valid sale" do
    sale = create(:sale, company: company, item: item)
    expect(sale).to be_persisted
  end

  it "validates presence of item_id" do
    sale = build(:sale, item_id: nil, company: company)
    expect(sale).not_to be_valid
  end

  it "validates presence of quantity" do
    sale = build(:sale, quantity: nil, company: company, item: item)
    expect(sale).not_to be_valid
  end

  it "validates presence of unit_price" do
    sale = build(:sale, unit_price: nil, company: company, item: item)
    expect(sale).not_to be_valid
  end

  it "belongs to company" do
    sale = create(:sale, company: company, item: item)
    expect(sale.company).to eq(company)
  end

  it "belongs to item" do
    sale = create(:sale, company: company, item: item)
    expect(sale.item).to eq(item)
  end

  it "multiplies quantity by unit_price" do
    sale = create(:sale, company: company, item: item, quantity: 2, unit_price: 100)
    expect(sale.total_price).to eq(200)
  end

  it "filters sales by company" do
    other_company = create(:company)
    other_item = create(:item, company: other_company, quantity_in_stock: 100)
    sale1 = create(:sale, company: company, item: item)
    sale2 = create(:sale, company: other_company, item: other_item)

    expect(company.sales).to include(sale1)
    expect(company.sales).not_to include(sale2)
  end
end
