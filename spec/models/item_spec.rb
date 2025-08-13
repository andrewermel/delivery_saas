# spec/models/item_spec.rb
require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:company) { Company.create!(name: "Empresa Teste", cnpj_id: "12345678901234") }
  let(:item) { Item.new(name: "Carne 150g", weight: 150, price: 20, company: company) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(item).to be_valid
    end

    it "is invalid without a name" do
      item.name = nil
      expect(item).not_to be_valid
    end

    it "is invalid without a weight" do
      item.weight = nil
      expect(item).not_to be_valid
    end

    it "is invalid without a company" do
      item.company = nil
      expect(item).not_to be_valid
    end
  end

  describe "associations" do
    it "belongs to a company" do
      assoc = Item.reflect_on_association(:company)
      expect(assoc.macro).to eq :belongs_to
    end
  end
end
