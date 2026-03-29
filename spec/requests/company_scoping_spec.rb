require "rails_helper"

RSpec.describe "Company Scoping and Security", type: :request do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:company1) { user1.company }
  let(:company2) { user2.company }
  let!(:purchase1) { create(:purchase, company: company1) }
  let!(:purchase2) { create(:purchase, company: company2) }

  describe "Purchase Access Control" do
    describe "Index - User should only see their own purchases" do
      it "user1 sees only their purchases" do
        sign_in user1
        get purchases_url
        expect(response).to have_http_status(:ok)
        # Verify user1's purchase is visible but not user2's
        expect(assigns(:purchases)).to include(purchase1)
        expect(assigns(:purchases)).not_to include(purchase2)
      end

      it "user2 sees only their purchases" do
        sign_in user2
        get purchases_url
        expect(response).to have_http_status(:ok)
        expect(assigns(:purchases)).to include(purchase2)
        expect(assigns(:purchases)).not_to include(purchase1)
      end
    end

    describe "Show - User cannot access purchase from another company" do
      it "user1 CAN access their own purchase" do
        sign_in user1
        get purchase_url(purchase1)
        expect(response).to have_http_status(:ok)
      end

      it "user1 CANNOT access purchase from user2" do
        sign_in user1
        expect {
          get purchase_url(purchase2)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe "Create - User can only create purchases for their company" do
      let(:item1) { create(:item, company: company1) }
      let(:item2) { create(:item, company: company2) }

      it "user1 CAN create purchase with their item" do
        sign_in user1
        expect {
          post purchases_url, params: {
            purchase: {
              item_name: "Test",
              price: 100,
              quantity: 1,
              item_id: item1.id
            }
          }
        }.to change(Purchase, :count).by(1)
      end

      it "user1 CANNOT create purchase with user2's item" do
        sign_in user1
        expect {
          post purchases_url, params: {
            purchase: {
              item_name: "Test",
              price: 100,
              quantity: 1,
              item_id: item2.id
            }
          }
        }.not_to change(Purchase, :count)
      end
    end
  end

  describe "Sale Access Control" do
    let!(:sale1) { create(:sale, company: company1) }
    let!(:sale2) { create(:sale, company: company2) }

    describe "Index - User should only see their own sales" do
      it "user1 sees only their sales" do
        sign_in user1
        get sales_url
        expect(response).to have_http_status(:ok)
        expect(assigns(:sales)).to include(sale1)
        expect(assigns(:sales)).not_to include(sale2)
      end
    end

    describe "Show - User cannot access sale from another company" do
      it "user1 CANNOT access sale from user2" do
        sign_in user1
        expect {
          get sale_url(sale2)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "Item Access Control" do
    let!(:item1) { create(:item, company: company1) }
    let!(:item2) { create(:item, company: company2) }

    describe "Index - User should only see their items" do
      it "user1 sees only their items" do
        sign_in user1
        get items_url
        expect(response).to have_http_status(:ok)
        expect(assigns(:items)).to include(item1)
        expect(assigns(:items)).not_to include(item2)
      end
    end
  end

  describe "Company Access Control" do
    describe "Index - User should only see their company" do
      it "user1 sees only their company" do
        sign_in user1
        get companies_url
        expect(response).to have_http_status(:ok)
        expect(assigns(:companies)).to include(company1)
        expect(assigns(:companies)).not_to include(company2)
      end
    end

    describe "Show - User cannot access another company" do
      it "user1 CANNOT access user2's company" do
        sign_in user1
        expect {
          get company_url(company2)
        }.to raise_error(ActiveRecord::RecordNotFound) # Would redirect, but we're testing the controller
      end
    end
  end
end
