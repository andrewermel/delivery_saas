require "rails_helper"

RSpec.describe PurchasesController, type: :controller do
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company) }
  let(:item) { create(:item, company: company) } # <-- item para satisfazer foreign key

  let(:valid_params) do
    { purchase: { item_name: "Item A", price: 100, weight: 10, item_id: item.id } }
  end

  let(:invalid_params) do
    { purchase: { item_name: "", price: nil, weight: nil, item_id: nil } }
  end

  before do
    # Skip Devise authentication
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    it "returns success" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    it "returns success" do
      purchase = create(:purchase, company: company, item: item)
      get :show, params: { id: purchase.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #new" do
    it "returns success" do
      get :new
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new purchase" do
        expect {
          post :create, params: valid_params
        }.to change(Purchase, :count).by(1)
      end

      it "redirects to the created purchase" do
        post :create, params: valid_params
        expect(response).to redirect_to(Purchase.last)
      end
    end

    context "with invalid params" do
      it "does not create a new purchase" do
        expect {
          post :create, params: invalid_params
        }.not_to change(Purchase, :count)
      end

      it "renders new template again" do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH #update" do
    let(:purchase) { create(:purchase, company: company, item: item, item_name: "Old Name") }

    it "updates the purchase" do
      patch :update, params: { id: purchase.id, purchase: { item_name: "New Name" } }
      expect(purchase.reload.item_name).to eq("New Name")
      expect(response).to redirect_to(purchase)
    end
  end

  describe "DELETE #destroy" do
    it "deletes the purchase" do
      purchase = create(:purchase, company: company, item: item)
      expect {
        delete :destroy, params: { id: purchase.id }
      }.to change(Purchase, :count).by(-1)
      expect(response).to redirect_to(purchases_path)
    end
  end
end
