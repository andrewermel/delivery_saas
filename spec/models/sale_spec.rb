require "rails_helper"

RSpec.describe Sale, type: :model do
  let(:company) { create(:company) }
  let(:item) { create(:item, company: company, quantity_in_stock: 100) }

  describe "associations" do
    it "belongs to company" do
      sale = build(:sale, company: company, item: item)
      expect(sale.company).to be_a(Company)
    end

    it "belongs to item" do
      sale = build(:sale, company: company, item: item)
      expect(sale.item).to be_a(Item)
    end
  end

  describe "validations" do
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

    it "validates presence of company_id" do
      sale = build(:sale, company: nil, item: item)
      expect(sale).not_to be_valid
    end

    it "validates quantity is greater than 0" do
      sale = build(:sale, quantity: 0, company: company, item: item)
      expect(sale).not_to be_valid
    end

    it "validates unit_price is greater than or equal to 0" do
      sale = build(:sale, unit_price: -10, company: company, item: item)
      expect(sale).not_to be_valid
    end
  end

  describe "#total_price" do
    it "multiplies quantity by unit_price" do
      sale = create(:sale, company: company, item: item, quantity: 2, unit_price: 100)
      expect(sale.total_price).to eq(200)
    end
  end

  describe "scoping to company" do
    let(:other_company) { create(:company) }
    let(:other_item) { create(:item, company: other_company, quantity_in_stock: 100) }
    let(:sale_company1) { create(:sale, company: company, item: item) }
    let(:sale_company2) { create(:sale, company: other_company, item: other_item) }

    it "filters sales by company" do
      expect(company.sales).to include(sale_company1)
      expect(company.sales).not_to include(sale_company2)
    end
  end

  describe "decimal precision" do
    it "stores unit_price with precision" do
      sale = create(:sale, 
        company: company, 
        item: item,
        unit_price: 99.99,
        quantity: 1
      )
      expect(sale.unit_price).to eq(99.99)
    end

    it "calculates total_price correctly with decimals" do
      sale = create(:sale,
        company: company,
        item: item,
        unit_price: 99.99,
        quantity: 3
      )
      expect(sale.total_price).to eq(299.97)
    end
  end

  describe "date handling" do
    it "accepts sale_date" do
      sale = build(:sale, 
        company: company,
        item: item,
        sale_date: Date.today
      )
      expect(sale.sale_date).to eq(Date.today)
    end
  end

  describe "creation and persistence" do
    it "creates a valid sale" do
      sale = create(:sale, company: company, item: item)
      expect(sale.persisted?).to be true
      expect(Sale.find(sale.id)).to eq(sale)
    end

    it "does not allow company_id to be nil if it's required" do
      sale = build(:sale, company: nil, item: item)
      expect(sale.valid?).to be false
    end
  end
end
