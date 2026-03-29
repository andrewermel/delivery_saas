require "rails_helper"

RSpec.describe "/pages", type: :request do
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company) }

  before { sign_in user }

  describe "GET /dashboard" do
    it "renders a successful response" do
      get dashboard_url
      expect(response).to have_http_status(:ok)
    end

    context "with no data" do
      it "displays zero for all metrics" do
        get dashboard_url
        expect(assigns(:total_purchases)).to eq(0)
        expect(assigns(:total_sales)).to eq(0)
        expect(assigns(:net_revenue)).to eq(0)
      end
    end

    context "with purchases and sales data" do
      before do
        # Create items
        @item1 = create(:item, company: company, price: 100)
        @item2 = create(:item, company: company, price: 50)

        # Create purchase
        create(:purchase, company: company, item: @item1, price: 100, quantity: 2)
        
        # Create sale
        create(:sale, company: company, item: @item1, quantity: 1, unit_price: 100)
      end

      it "correctly calculates total_purchases" do
        get dashboard_url
        # Should sum all purchase prices: 100 * 1 = 100
        expect(assigns(:total_purchases)).to eq(100)
      end

      it "correctly calculates total_sales" do
        get dashboard_url
        # Should sum all sale totals: 100 * 1 = 100
        expect(assigns(:total_sales)).to eq(100)
      end

      it "correctly calculates net_revenue" do
        get dashboard_url
        # net_revenue = total_sales - total_purchases = 100 - 100 = 0
        expect(assigns(:net_revenue)).to eq(0)
      end

      it "shows only user's company data" do
        other_company = create(:company)
        other_purchase = create(:purchase, company: other_company, price: 1000)
        
        get dashboard_url
        # Should still be 100, not 100 + 1000
        expect(assigns(:total_purchases)).to eq(100)
      end
    end

    context "with profit scenario" do
      before do
        item = create(:item, company: company, price: 50)
        # Purchase at 50
        create(:purchase, company: company, item: item, price: 50, quantity: 1)
        # Sell at 100
        create(:sale, company: company, item: item, quantity: 1, unit_price: 100)
      end

      it "calculates positive net_revenue" do
        get dashboard_url
        # net_revenue = 100 - 50 = 50
        expect(assigns(:net_revenue)).to eq(50)
      end
    end

    context "with loss scenario" do
      before do
        item = create(:item, company: company, price: 100)
        # Purchase at 100
        create(:purchase, company: company, item: item, price: 100, quantity: 1)
        # Sell at 50
        create(:sale, company: company, item: item, quantity: 1, unit_price: 50)
      end

      it "calculates negative net_revenue" do
        get dashboard_url
        # net_revenue = 50 - 100 = -50
        expect(assigns(:net_revenue)).to eq(-50)
      end
    end
  end

  describe "GET /home" do
    context "when not signed in" do
      before { sign_out user }

      it "redirects to login" do
        get root_url
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context "when signed in" do
      it "renders successfully" do
        get root_url
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
