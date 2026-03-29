require "rails_helper"

RSpec.describe Company, type: :model do
  it "creates a valid company" do
    company = create(:company)
    expect(company).to be_persisted
  end

  it "validates presence of name" do
    company = build(:company, name: nil)
    expect(company).not_to be_valid
  end

  it "validates presence of cnpj_id" do
    company = build(:company, cnpj_id: nil)
    expect(company).not_to be_valid
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
end
