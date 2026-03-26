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

        update_item_price(@purchase.item_id)

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
        update_item_price(@purchase.item_id)  # Adicionando esta linha
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
    item_id = @purchase.item_id  # Guarda o item_id antes de deletar
    @purchase.destroy!
    update_item_price(item_id)   # Atualiza o preço após deletar

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

    def update_item_price(item_id)
      return unless item_id.present?

      item = current_company.items.find_by(id: item_id)
      return unless item.present?

      # Calculando média apenas das compras da mesma empresa
      average_price = Purchase.where(company_id: current_company.id, item_id: item_id)
                            .average(:price) || 0

      item.update(price: average_price)
    end
end
