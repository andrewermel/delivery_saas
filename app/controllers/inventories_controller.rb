class InventoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_company

  def index
    @items_in_stock = @current_company.items.in_stock.includes(:purchases).order(name: :asc)
    @total_invested = calculate_total_invested
    @inventory_movements = Inventory.where(company_id: @current_company.id).order(created_at: :desc).limit(20)
  end

  def show_transactions
    @selected_month = params[:month].to_i
    @selected_year = params[:year].to_i
    @selected_month = Date.today.month if @selected_month.zero?
    @selected_year = Date.today.year if @selected_year.zero?

    start_date = Date.new(@selected_year, @selected_month, 1)
    end_date = start_date.end_of_month

    @page = (params[:page] || 1).to_i
    @per_page = 25

    all_movements = Inventory.where(company_id: @current_company.id)
                            .where(created_at: start_date.beginning_of_day..end_date.end_of_day)
                            .includes(:item, :purchase, :sale)
                            .order(created_at: :desc)

    @total_movements = all_movements.count
    @total_pages = (@total_movements / @per_page.to_f).ceil
    @movements = all_movements.offset((@page - 1) * @per_page).limit(@per_page)
  end

  private

  def set_current_company
    @current_company = current_user.company
  end

  def calculate_total_invested
    @current_company.items.in_stock.sum { |item| (item.price.to_f * item.quantity_in_stock).round(2) }
  end
end
