require "rails_helper"

RSpec.describe Inventory, type: :model do
  let(:company) { create(:company) }
  let(:item) { create(:item, company: company) }

  it "creates a valid inventory entry" do
    inventory = create(:inventory, company: company, item: item)
    expect(inventory).to be_persisted
  end

  it "validates presence of company_id" do
    inventory = build(:inventory, company: nil, item: item)
    expect(inventory).not_to be_valid
  end

  it "validates presence of item_id" do
    inventory = build(:inventory, company: company, item: nil)
    expect(inventory).not_to be_valid
  end

  it "validates presence of movement_type" do
    inventory = build(:inventory, company: company, item: item, movement_type: nil)
    expect(inventory).not_to be_valid
  end

  it "accepts 'purchase' as movement_type" do
    inventory = build(:inventory, company: company, item: item, movement_type: "purchase")
    expect(inventory).to be_valid
  end

  it "accepts 'sale' as movement_type" do
    inventory = build(:inventory, company: company, item: item, movement_type: "sale")
    expect(inventory).to be_valid
  end

  it "rejects invalid movement_type" do
    inventory = build(:inventory, company: company, item: item, movement_type: "invalid")
    expect(inventory).not_to be_valid
  end

  it "belongs to company" do
    inventory = create(:inventory, company: company, item: item)
    expect(inventory.company).to eq(company)
  end

  it "belongs to item" do
    inventory = create(:inventory, company: company, item: item)
    expect(inventory.item).to eq(item)
  end
end
