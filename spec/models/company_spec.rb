require "rails_helper"

RSpec.describe Company, type: :model do
  describe "associations" do
    it "has many users" do
      company = create(:company)
      user = create(:user, company: company)
      expect(company.users).to include(user)
    end

    it "has many items" do
      company = create(:company)
      item = create(:item, company: company)
      expect(company.items).to include(item)
    end

    it "has many purchases" do
      company = create(:company)
      item = create(:item, company: company)
      purchase = create(:purchase, company: company, item: item)
      expect(company.purchases).to include(purchase)
    end

    it "has many sales" do
      company = create(:company)
      item = create(:item, company: company)
      sale = create(:sale, company: company, item: item, quantity: 5)
      expect(company.sales).to include(sale)
    end
  end

  describe "validations" do
    it "validates presence of name" do
      company = build(:company, name: nil)
      expect(company).not_to be_valid
    end

    it "validates presence of cnpj_id" do
      company = build(:company, cnpj_id: nil)
      expect(company).not_to be_valid
    end

    it "validates uniqueness of cnpj_id" do
      create(:company, cnpj_id: "12345678901234")
      company = build(:company, cnpj_id: "12345678901234")
      expect(company).not_to be_valid
    end
  end

  describe "creation and persistence" do
    it "creates a valid company" do
      company = create(:company)
      expect(company.persisted?).to be true
      expect(Company.find(company.id)).to eq(company)
    end

    it "does not allow name to be nil" do
      company = build(:company, name: nil)
      expect(company).not_to be_valid
    end

    it "does not allow cnpj_id to be nil" do
      company = build(:company, cnpj_id: nil)
      expect(company).not_to be_valid
    end
  end

  describe "user relationships" do
    let(:company) { create(:company) }
    let(:user1) { create(:user, company: company) }
    let(:user2) { create(:user, company: company) }

    it "has many users" do
      expect(company.users).to include(user1, user2)
    end

    it "destroys dependent users when company is deleted" do
      user_id = user1.id
      company.destroy
      expect(User.exists?(user_id)).to be false
    end
  end

  describe "item relationships" do
    let(:company) { create(:company) }
    let(:item1) { create(:item, company: company) }
    let(:item2) { create(:item, company: company) }

    it "has many items" do
      expect(company.items).to include(item1, item2)
    end

    it "only includes items belonging to this company" do
      other_company = create(:company)
      other_item = create(:item, company: other_company)
      
      expect(company.items).not_to include(other_item)
    end
  end

  describe "purchase relationships" do
    let(:company) { create(:company) }
    let(:item) { create(:item, company: company) }
    let(:purchase1) { create(:purchase, company: company, item: item) }
    let(:purchase2) { create(:purchase, company: company, item: item) }

    it "has many purchases" do
      expect(company.purchases).to include(purchase1, purchase2)
    end
  end

  describe "sale relationships" do
    let(:company) { create(:company) }
    let(:item) { create(:item, company: company, quantity_in_stock: 100) }
    let(:sale1) { create(:sale, company: company, item: item, quantity: 5) }
    let(:sale2) { create(:sale, company: company, item: item, quantity: 3) }

    it "has many sales" do
      expect(company.sales).to include(sale1, sale2)
    end
  end

  describe "multi-tenancy" do
    let(:company1) { create(:company) }
    let(:company2) { create(:company) }

    it "keeps data isolated between companies" do
      item1 = create(:item, company: company1)
      item2 = create(:item, company: company2)

      expect(company1.items).to include(item1)
      expect(company1.items).not_to include(item2)
      expect(company2.items).to include(item2)
      expect(company2.items).not_to include(item1)
    end
  end
end
