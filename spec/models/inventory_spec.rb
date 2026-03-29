require "rails_helper"

RSpec.describe Inventory, type: :model do
  let(:company) { create(:company) }
  let(:item) { create(:item, company: company) }

  describe "associations" do
    it "belongs to company" do
      inventory = build(:inventory, company: company, item: item)
      expect(inventory.company).to be_a(Company)
    end

    it "belongs to item" do
      inventory = build(:inventory, company: company, item: item)
      expect(inventory.item).to be_a(Item)
    end

    it "belongs to purchase (optional)" do
      inventory = build(:inventory, company: company, item: item, purchase: nil)
      expect(inventory).to be_valid
    end

    it "belongs to sale (optional)" do
      inventory = build(:inventory, company: company, item: item, sale: nil)
      expect(inventory).to be_valid
    end
  end

  describe "validations" do
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

    it "validates presence of quantity_change" do
      inventory = build(:inventory, company: company, item: item, quantity_change: nil)
      expect(inventory).not_to be_valid
    end
  end

  describe "movement types" do
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
  end

  describe "tracking purchases" do
    it "creates inventory entry when purchase is created" do
      purchase = create(:purchase, company: company, item: item, quantity: 5)
      inventory = Inventory.find_by(purchase: purchase)
      
      expect(inventory).not_to be_nil
      expect(inventory.movement_type).to eq("purchase")
      expect(inventory.quantity_change).to eq(5)
    end
  end

  describe "tracking sales" do
    it "creates inventory entry when sale is created" do
      sale = create(:sale, company: company, item: item, quantity: 3)
      inventory = Inventory.find_by(sale: sale)
      
      expect(inventory).not_to be_nil
      expect(inventory.movement_type).to eq("sale")
      expect(inventory.quantity_change).to eq(-3)
    end
  end

  describe "scoping to company" do
    let(:other_company) { create(:company) }
    let(:other_item) { create(:item, company: other_company) }

    it "only includes inventory for company's items" do
      purchase = create(:purchase, company: company, item: item)
      other_purchase = create(:purchase, company: other_company, item: other_item)

      expect(company.inventories.count).to be > 0
      expect(company.inventories.find_by_id(other_purchase.inventories.pluck(:id))).to be_nil
    end
  end

  describe "creation and persistence" do
    it "creates a valid inventory entry" do
      inventory = create(:inventory, company: company, item: item)
      expect(inventory.persisted?).to be true
      expect(Inventory.find(inventory.id)).to eq(inventory)
    end
  end
end
