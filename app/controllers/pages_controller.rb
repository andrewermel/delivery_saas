class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]

  def home
    # Se usuário está logado, redireciona para dashboard
    redirect_to dashboard_path if user_signed_in?
  end

  def dashboard
    @current_company = current_user.company
    
    # Filtro por mês
    @selected_month = params[:month].to_i
    @selected_year = params[:year].to_i
    @selected_month = Date.today.month if @selected_month.zero?
    @selected_year = Date.today.year if @selected_year.zero?
    
    # Período do mês selecionado
    start_date = Date.new(@selected_year, @selected_month, 1)
    end_date = start_date.end_of_month
    
    @total_invested = calculate_total_invested
    @items_in_stock = @current_company.items.where("quantity_in_stock > 0").order(name: :asc)
    @recent_movements = Inventory.where(company_id: @current_company.id)
                                 .includes(:item, :purchase, :sale)
                                 .order(created_at: :desc)
                                 .limit(10)
    
    # Estatísticas gerais
    @total_items = @current_company.items.count
    @total_quantity = @current_company.items.sum(:quantity_in_stock)
    @recent_purchases = @current_company.purchases.count
    @recent_sales = @current_company.sales.count
    
    # Estatísticas do mês selecionado
    @total_purchases_month = @current_company.purchases
                                            .where(created_at: start_date.beginning_of_day..end_date.end_of_day)
                                            .sum(:price)
                                            .to_f
                                            .round(2)
    
    @total_sales_month = @current_company.sales
                                        .where(created_at: start_date.beginning_of_day..end_date.end_of_day)
                                        .sum(:total_price)
                                        .to_f
                                        .round(2)
    
    @net_revenue = (@total_sales_month - @total_purchases_month).round(2)
  end

  private

  def calculate_total_invested
    # O campo "price" em purchases é o TOTAL da compra, não unitário
    # Então basta somar todos os preços das compras
    @current_company.purchases.sum(:price).to_f.round(2)
  end
end
