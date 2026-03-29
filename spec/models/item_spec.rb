require "rails_helper"

RSpec.describe Item, type: :model do
  let(:company) { create(:company) }

  it "creates a valid item" do
    item = create(:item, company: company)
    expect(item).to be_persisted
  end

  it "validates presence of name" do
    item = build(:item, name: nil, company: company)
    expect(item).not_to be_valid
  end

  it "validates presence of price" do
    item = build(:item, price: nil, company: company)
    expect(item).not_to be_valid
  end

  it "belongs to a company" do
    item = create(:item, company: company)
    expect(item.company).to eq(company)
  end

  it "filters items by company" do
    other_company = create(:company)
    item1 = create(:item, company: company)
    item2 = create(:item, company: other_company)

    expect(company.items).to include(item1)
    expect(company.items).not_to include(item2)
  end

  it "has many purchases" do
    item = create(:item, company: company)
    purchase = create(:purchase, item: item, company: company)
    expect(item.purchases).to include(purchase)
  end

  it "has many sales" do
    item = create(:item, company: company, quantity_in_stock: 100)
    sale = create(:sale, item: item, company: company, quantity: 5)
    expect(item.sales).to include(sale)
  end

  it "calculates total_invested" do
    item = create(:item, company: company)
    create(:purchase, item: item, company: company, price: 100)
    create(:purchase, item: item, company: company, price: 50)
    expect(item.total_invested).to eq(150)
  end

  it "calculates total_sold" do
    item = create(:item, company: company, quantity_in_stock: 100)
    create(:sale, item: item, company: company, quantity: 1, unit_price: 100)
    create(:sale, item: item, company: company, quantity: 2, unit_price: 50)
    expect(item.total_sold).to eq(200)
  end

  it "calculates profit_margin" do
    item = create(:item, company: company, quantity_in_stock: 100)
    create(:purchase, item: item, company: company, price: 100)
    create(:sale, item: item, company: company, quantity: 1, unit_price: 150)
    expect(item.profit_margin).to eq(50)
  end
end
