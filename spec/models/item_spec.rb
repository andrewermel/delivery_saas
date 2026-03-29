require "rails_helper"

RSpec.describe Item, type: :model do
  let(:company) { create(:company) }

  describe "associations" do
    it "belongs to a company" do
      item = build(:item, company: company)
      expect(item.company).to be_a(Company)
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
  end

  describe "validations" do
    it "validates presence of name" do
      item = build(:item, name: nil, company: company)
      expect(item).not_to be_valid
    end

    it "validates presence of price" do
      item = build(:item, price: nil, company: company)
      expect(item).not_to be_valid
    end

    it "validates presence of company_id" do
      item = build(:item, company: nil)
      expect(item).not_to be_valid
    end

    it "validates numericality of price" do
      item = build(:item, price: "not a number", company: company)
      expect(item).not_to be_valid
    end

    it "validates uniqueness of name scoped to company" do
      create(:item, name: "Widget", company: company)
      item = build(:item, name: "Widget", company: company)
      expect(item).not_to be_valid
    end

    it "allows same name for different companies" do
      other_company = create(:company)
      create(:item, name: "Widget", company: company)
      item = build(:item, name: "Widget", company: other_company)
      expect(item).to be_valid
    end
  end

  describe "#total_invested" do
    let(:item) { create(:item, company: company) }

    context "with no purchases" do
      it "returns zero" do
        expect(item.total_invested).to eq(0)
      end
    end

    context "with purchases" do
      before do
        create(:purchase, item: item, company: company, price: 100, quantity: 2)
        create(:purchase, item: item, company: company, price: 50, quantity: 1)
      end

      it "sums all purchase prices" do
        # 100 + 50 = 150
        expect(item.total_invested).to eq(150)
      end
    end
  end

  describe "#total_sold" do
    let(:item) { create(:item, company: company) }

    context "with no sales" do
      it "returns zero" do
        expect(item.total_sold).to eq(0)
      end
    end

    context "with sales" do
      before do
        create(:sale, item: item, company: company, quantity: 1, unit_price: 100)
        create(:sale, item: item, company: company, quantity: 2, unit_price: 50)
      end

      it "sums all sale totals" do
        # 100 + (50 * 2) = 200
        expect(item.total_sold).to eq(200)
      end
    end
  end

  describe "#profit_margin" do
    let(:item) { create(:item, company: company) }

    context "with profit" do
      before do
        create(:purchase, item: item, company: company, price: 100)
        create(:sale, item: item, company: company, quantity: 1, unit_price: 150)
      end

      it "calculates positive profit" do
        # 150 - 100 = 50
        expect(item.profit_margin).to eq(50)
      end
    end

    context "with loss" do
      before do
        create(:purchase, item: item, company: company, price: 200)
        create(:sale, item: item, company: company, quantity: 1, unit_price: 100)
      end

      it "calculates negative profit" do
        # 100 - 200 = -100
        expect(item.profit_margin).to eq(-100)
      end
    end

    context "with no transactions" do
      it "returns zero" do
        expect(item.profit_margin).to eq(0)
      end
    end
  end

  describe "scoping to company" do
    let(:other_company) { create(:company) }
    let(:item_company1) { create(:item, company: company) }
    let(:item_company2) { create(:item, company: other_company) }

    it "filters items by company" do
      expect(company.items).to include(item_company1)
      expect(company.items).not_to include(item_company2)
    end
  end

  describe "pricing" do
    it "accepts decimal prices" do
      item = create(:item, company: company, price: 99.99)
      expect(item.price).to eq(99.99)
    end

    it "validates positive price" do
      item = build(:item, company: company, price: -50)
      expect(item).not_to be_valid
    end

    it "validates price is not zero" do
      item = build(:item, company: company, price: 0)
      expect(item).not_to be_valid
    end
  end

  describe "creation and persistence" do
    it "creates a valid item" do
      item = create(:item, company: company)
      expect(item.persisted?).to be true
      expect(Item.find(item.id)).to eq(item)
    end

    it "does not allow company_id to be nil" do
      item = build(:item, company: nil)
      expect(item.valid?).to be false
    end
  end
end
