class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?
  
  helper_method :current_company

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  # Get current user's company (scoped security)
  def current_company
    current_user&.company
  end

  # Verify user can access a specific company (security check)
  def verify_company_access(company_id)
    return if current_user&.company_id == company_id
    redirect_to root_path, alert: "Você não tem permissão para acessar essa empresa."
  end
end
