class SalesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sale, only: %i[show edit update destroy]
  before_action :set_current_company

  def index
    @sales = @current_company.sales.includes(:item).order(created_at: :desc)
  end

  def show
  end

  def new
    @sale = @current_company.sales.build
    @items = @current_company.items
    @items_data = @items.map { |item| { id: item.id, name: item.name, price: item.price, suggested_price: (item.price.to_f * 2).round(2) } }
  end

  def edit
    @items = @current_company.items
    @items_data = @items.map { |item| { id: item.id, name: item.name, price: item.price, suggested_price: (item.price.to_f * 2).round(2) } }
  end

  def create
    @sale = @current_company.sales.build(sale_params)

    respond_to do |format|
      if @sale.save
        format.html { redirect_to @sale, notice: "Venda criada com sucesso." }
        format.json { render :show, status: :created, location: @sale }
      else
        format.html do
          @items = @current_company.items
          render :new, status: :unprocessable_entity
        end
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @sale.update(sale_params)
        format.html { redirect_to @sale, notice: "Venda atualizada com sucesso." }
        format.json { render :show, status: :ok, location: @sale }
      else
        format.html do
          @items = @current_company.items
          render :edit, status: :unprocessable_entity
        end
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sale.destroy!
    respond_to do |format|
      format.html { redirect_to sales_path, notice: "Venda deletada com sucesso." }
      format.json { head :no_content }
    end
  end

  private

  def set_sale
    @sale = Sale.find(params[:id])
    authorize_sale!
  end

  def set_current_company
    @current_company = current_user.company
  end

  def authorize_sale!
    redirect_to sales_path, alert: "Não autorizado." unless @sale.company == @current_company
  end

  def sale_params
    params.require(:sale).permit(:item_id, :quantity, :unit_price, :sale_date)
  end
end
