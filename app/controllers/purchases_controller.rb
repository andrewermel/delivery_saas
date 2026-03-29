class PurchasesController < ApplicationController
  before_action :set_purchase, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /purchases or /purchases.json
  def index
    @purchases = current_company.purchases.order(created_at: :desc)
  end

  # GET /purchases/1 or /purchases/1.json
  def show
  end

  # GET /purchases/new
  def new
    @purchase = Purchase.new
  end

  # GET /purchases/1/edit
  def edit
  end

  # POST /purchases or /purchases.json
  def create
   @purchase = Purchase.new(purchase_params.merge(company_id: current_user.company_id))

    respond_to do |format|
      if @purchase.save

        format.html { redirect_to @purchase, notice: "Purchase was successfully created." }
        format.json { render :show, status: :created, location: @purchase }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

 # PATCH/PUT /purchases/1 or /purchases/1.json
 def update
    respond_to do |format|
      if @purchase.update(purchase_params)
        format.html { redirect_to @purchase, notice: "Purchase was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @purchase }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases/1 or /purchases/1.json
  def destroy
    @purchase.destroy!

    respond_to do |format|
      format.html { redirect_to purchases_path, notice: "Purchase was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def current_company
      current_user.company
    end

    # Corrigir o set_purchase para usar current_company
    def set_purchase
      @purchase = current_company.purchases.find(params[:id])  # Mais seguro
    end

    # Corrigir o purchase_params (expect está errado, deve ser require)
    def purchase_params
      params.require(:purchase).permit(:item_name, :item_id, :price, :quantity)
    end
end
