require "rails_helper"

RSpec.describe Purchase, type: :model do
  let(:company) { create(:company) }
  let(:item) { create(:item, company: company) }

  it "creates a valid purchase" do
    purchase = create(:purchase, company: company, item: item)
    expect(purchase).to be_persisted
  end

  it "validates presence of item_name" do
    purchase = build(:purchase, item_name: nil, company: company)
    expect(purchase).not_to be_valid
  end

  it "validates presence of price" do
    purchase = build(:purchase, price: nil, company: company)
    expect(purchase).not_to be_valid
  end

  it "validates presence of quantity" do
    purchase = build(:purchase, quantity: nil, company: company)
    expect(purchase).not_to be_valid
  end

  it "belongs to company" do
    purchase = create(:purchase, company: company, item: item)
    expect(purchase.company).to eq(company)
  end

  it "can belong to an item" do
    purchase = create(:purchase, company: company, item: item)
    expect(purchase.item).to eq(item)
  end
end
