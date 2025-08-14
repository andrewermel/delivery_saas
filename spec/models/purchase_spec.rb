require "rails_helper"

RSpec.describe Purchase, type: :model do
  describe "associations" do
    it "belongs to a company" do
      company = Company.create!(name: "Test Company")
      purchase = Purchase.new(item_name: "Test Item", price: 10.0, weight: 2.0, company: company)
      expect(purchase.company).to eq(company)
    end

    it "can belong to an item" do
      company = Company.create!(name: "Test Company")
      # Ajuste: criar item com todos os atributos obrigatórios
      item = Item.create!(name: "Test Item", company: company, weight: 1.0, price: 5.0)
      purchase = Purchase.new(item_name: "Test Item", price: 10.0, weight: 2.0, company: company, item: item)
      expect(purchase.item).to eq(item)
    end
  end

  describe "validations" do
    let(:company) { Company.create!(name: "Test Company") }

    it "is invalid without item_name" do
      purchase = Purchase.new(price: 10.0, weight: 2.0, company: company)
      expect(purchase.valid?).to be_falsey
      expect(purchase.errors[:item_name]).to include("can't be blank")
    end

    it "is invalid without price" do
      purchase = Purchase.new(item_name: "Test Item", weight: 2.0, company: company)
      expect(purchase.valid?).to be_falsey
      expect(purchase.errors[:price]).to include("can't be blank")
    end

    it "is invalid without weight" do
      purchase = Purchase.new(item_name: "Test Item", price: 10.0, company: company)
      expect(purchase.valid?).to be_falsey
      expect(purchase.errors[:weight]).to include("can't be blank")
    end

    it "is valid with all required attributes" do
      purchase = Purchase.new(item_name: "Test Item", price: 10.0, weight: 2.0, company: company)
      expect(purchase.valid?).to be_truthy
    end
  end
end
