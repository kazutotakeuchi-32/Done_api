
class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configre_permitted_parameters, if: :devise_controller?
  protected
    def configre_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name] )
      devise_parameter_sanitizer.permit(:account_update, keys: [:name,:email,:avatar] )
    end

end
