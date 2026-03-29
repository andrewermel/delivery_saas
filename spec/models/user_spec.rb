require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it "belongs to company (optional)" do
      user = build(:user, company: nil)
      expect(user).to be_valid
    end

    it "can have a company association" do
      company = create(:company)
      user = build(:user, company: company)
      expect(user.company).to eq(company)
    end
  end

  describe "after_create callback" do
    it "creates a company automatically" do
      user = User.create!(email: "test@example.com", password: "password123")
      
      expect(user.company).not_to be_nil
      expect(user.company.name.downcase).to include("test")
      expect(user.company_id).to eq(user.company.id)
    end

    it "assigns user to created company" do
      user = User.create!(email: "newuser@example.com", password: "password123")
      
      expect(user.reload.company).to be_persisted
      expect(user.company.users).to include(user)
    end

    it "generates unique CNPJ for created company" do
      user1 = User.create!(email: "user1@example.com", password: "password123")
      user2 = User.create!(email: "user2@example.com", password: "password123")
      
      expect(user1.company.cnpj_id).not_to eq(user2.company.cnpj_id)
    end
  end

  describe "validations" do
    it "validates presence of email" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it "validates uniqueness of email" do
      create(:user, email: "test@example.com")
      user = build(:user, email: "test@example.com")
      expect(user).not_to be_valid
    end

    it "validates presence of password" do
      user = User.new(email: "test@example.com", password: nil)
      expect(user).not_to be_valid
    end
  end

  describe "enum roles" do
    it "has user role as default" do
      user = create(:user)
      expect(user.role_user?).to be true
    end

    it "can be assigned admin role" do
      user = create(:user)
      user.update(role: :admin)
      expect(user.admin_role?).to be true
    end
  end
end
