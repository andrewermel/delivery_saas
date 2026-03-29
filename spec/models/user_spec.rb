require "rails_helper"

RSpec.describe User, type: :model do
  it "creates a user with email" do
    user = create(:user, email: "test@example.com")
    expect(user).to be_persisted
    expect(user.email).to eq("test@example.com")
  end

  it "validates presence of email" do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
  end

  it "creates a company automatically on user creation" do
    user = User.create!(email: "newuser@example.com", password: "password123")
    expect(user.company).not_to be_nil
    expect(user.company).to be_persisted
  end

  it "assigns user to created company" do
    user = User.create!(email: "newuser@example.com", password: "password123")
    expect(user.reload.company).to be_persisted
    expect(user.company.users).to include(user)
  end

  it "belongs to optional company" do
    company = create(:company)
    user = build(:user, company: company)
    expect(user.company).to eq(company)
  end
end
