class ItemsController < ApplicationController
  before_action :authenticate_user!                    # Require login for all actions
  before_action :set_item, only: %i[ show edit update destroy ]

  # GET /items
  def index
    # Admin sees everything; regular users see only their company's records
    @items = current_user.admin_role? ? Item.all : Item.where(company_id: current_user.company_id)
  end

  # GET /items/1
  def show
    # @item already scoped in set_item
  end

  # GET /items/new
  def new
    # Initialize a new item; company will be enforced on create
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
    # @item already scoped in set_item
  end


  def create
    @item =  Item.new(item_params.merge(company_id: current_user.company_id))

    @item.company = if current_user.admin_role? && params.dig(:item, :company_id).present?
                      Company.find(params[:item][:company_id])
                    else
                      current_user.company
                    end

    if @item.save
      respond_to do |format|
        format.html { redirect_to @item, notice: "Item was successfully created." }
        format.json { render :show, status: :created, location: @item }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  def update
    # Prevent switching company via params for non-admins
    if current_user.admin_role? && params.dig(:item, :company_id).present?
      @item.company = Company.find(params[:item][:company_id])
    end

    if @item.update(item_params.except(:company_id))
      respond_to do |format|
        format.html { redirect_to @item, notice: "Item was successfully updated." }
        format.json { render :show, status: :ok, location: @item }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: "Item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    # Scope find by company for regular users; admin can access any item
    @item = if current_user.admin_role?
              Item.find(params[:id])
            else
              Item.find_by!(id: params[:id], company_id: current_user.company_id)
            end
  end

  # Only allow a list of trusted parameters through.
  def item_params
    # Permit company_id for admins (we still ignore it for non-admins in create/update)
    params.require(:item).permit(:name, :weight, :price)
  end
end
