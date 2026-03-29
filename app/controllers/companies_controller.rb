class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: %i[ show edit update destroy ]
  before_action :verify_ownership, only: %i[ show edit update destroy ]

  # GET /companies or /companies.json
  def index
    # Users only see their own company; admins can see all
    @companies = current_user.admin_role? ? Company.all : [current_user.company].compact
  end

  # GET /companies/1 or /companies/1.json
  def show
  end

  # GET /companies/new
  def new
    # Regular users cannot create new companies (created automatically on signup)
    redirect_to companies_path, alert: "Empresas são criadas automaticamente no registro." unless current_user.admin_role?
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies or /companies.json
  def create
    # Prevent regular users from creating companies
    redirect_to companies_path, alert: "Você não tem permissão para criar empresas." unless current_user.admin_role?
  end

  # PATCH/PUT /companies/1 or /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: "Company was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1 or /companies/1.json
  def destroy
    @company.destroy!

    respond_to do |format|
      format.html { redirect_to companies_path, notice: "Company was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params.expect(:id))
    end

    # Verify user owns this company
    def verify_ownership
      unless current_user.admin_role? || @company.id == current_user.company_id
        redirect_to companies_path, alert: "Você não tem permissão para acessar essa empresa."
      end
    end

    # Only allow a list of trusted parameters through.
    def company_params
      params.expect(company: [ :name, :cnpj_id ])
    end
end
