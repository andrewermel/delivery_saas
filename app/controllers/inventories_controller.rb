class InventoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_company

  def index
    @items_in_stock = @current_company.items.where("quantity_in_stock > 0").includes(:purchases).order(name: :asc)
    @total_invested = calculate_total_invested
    @inventory_movements = Inventory.where(company_id: @current_company.id).order(created_at: :desc).limit(20)
  end

  def show_transactions
    @movements = Inventory.where(company_id: @current_company.id)
                          .includes(:item, :purchase, :sale)
                          .order(created_at: :desc)
                          .page(params[:page])
                          .per(25)
  end

  private

  def set_current_company
    @current_company = current_user.company
  end

  def calculate_total_invested
    @current_company.items.where("quantity_in_stock > 0").sum do |item|
      (item.price.to_f * item.quantity_in_stock).round(2)
    end
  end
end
