require "rails_helper"

RSpec.describe "/sales", type: :request do
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company) }
  let(:item) { create(:item, company: company) }

  let(:valid_attributes) do
    {
      item_id: item.id,
      quantity: 1,
      unit_price: 100,
      sale_date: Date.today
    }
  end

  let(:invalid_attributes) do
    {
      item_id: nil,
      quantity: nil,
      unit_price: nil,
      sale_date: nil
    }
  end

  before { sign_in user }

  describe "GET /index" do
    it "renders a successful response" do
      create(:sale, company: company)
      get sales_url
      expect(response).to have_http_status(:ok)
    end

    it "displays only user's company sales" do
      other_company = create(:company)
      sale_mine = create(:sale, company: company)
      sale_other = create(:sale, company: other_company)
      
      get sales_url
      expect(assigns(:sales)).to include(sale_mine)
      expect(assigns(:sales)).not_to include(sale_other)
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      sale = create(:sale, company: company)
      get sale_url(sale)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_sale_url
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Sale" do
        expect {
          post sales_url, params: { sale: valid_attributes }
        }.to change(Sale, :count).by(1)
      end

      it "redirects to the created sale" do
        post sales_url, params: { sale: valid_attributes }
        expect(response).to redirect_to(sale_url(Sale.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Sale" do
        expect {
          post sales_url, params: { sale: invalid_attributes }
        }.not_to change(Sale, :count)
      end

      it "renders a response with 422 status" do
        post sales_url, params: { sale: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when trying to use item from another company" do
      it "does not create the sale" do
        other_company = create(:company)
        other_item = create(:item, company: other_company)
        
        expect {
          post sales_url, params: {
            sale: valid_attributes.merge(item_id: other_item.id)
          }
        }.not_to change(Sale, :count)
      end

      it "redirects with alert" do
        other_company = create(:company)
        other_item = create(:item, company: other_company)
        
        post sales_url, params: {
          sale: valid_attributes.merge(item_id: other_item.id)
        }
        expect(response).to redirect_to(sales_url)
      end
    end
  end

  describe "PATCH /update" do
    it "updates the requested sale" do
      sale = create(:sale, company: company, quantity: 1)
      patch sale_url(sale), params: { sale: { quantity: 5 } }
      expect(sale.reload.quantity).to eq(5)
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested sale" do
      sale = create(:sale, company: company)
      expect {
        delete sale_url(sale)
      }.to change(Sale, :count).by(-1)
    end
  end
end
