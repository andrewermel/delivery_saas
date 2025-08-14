require "rails_helper"

RSpec.describe "/purchases", type: :request do
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company) }

  let(:valid_attributes) do
    {
      item_name: "Item A",
      price: 100,
      weight: 10,
      company_id: company.id
    }
  end

  let(:invalid_attributes) do
    {
      item_name: "",
      price: nil,
      weight: nil,
      company_id: nil
    }
  end

  before do
    # Sign in the user for Devise
    sign_in user
  end

  describe "GET /index" do
    it "renders a successful response" do
      Purchase.create!(valid_attributes)
      get purchases_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      purchase = Purchase.create!(valid_attributes)
      get purchase_url(purchase)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_purchase_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      purchase = Purchase.create!(valid_attributes)
      get edit_purchase_url(purchase)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Purchase" do
        expect {
          post purchases_url, params: { purchase: valid_attributes }
        }.to change(Purchase, :count).by(1)
      end

      it "redirects to the created purchase" do
        post purchases_url, params: { purchase: valid_attributes }
        expect(response).to redirect_to(purchase_url(Purchase.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Purchase" do
        expect {
          post purchases_url, params: { purchase: invalid_attributes }
        }.not_to change(Purchase, :count)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post purchases_url, params: { purchase: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /update" do
    let(:purchase) { Purchase.create!(valid_attributes.merge(item_name: "Old Name")) }

    it "updates the requested purchase" do
      patch purchase_url(purchase), params: { purchase: { item_name: "New Name" } }
      expect(purchase.reload.item_name).to eq("New Name")
      expect(response).to redirect_to(purchase_url(purchase))
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested purchase" do
      purchase = Purchase.create!(valid_attributes)
      expect {
        delete purchase_url(purchase)
      }.to change(Purchase, :count).by(-1)
      expect(response).to redirect_to(purchases_url)
    end
  end
end
