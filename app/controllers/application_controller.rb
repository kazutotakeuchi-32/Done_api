
class ApplicationController < ActionController::API

        include DeviseTokenAuth::Concerns::SetUserByToken
        before_action :configre_permitted_parameters, if: :devise_controller?
        protected
         def configre_permitted_parameters
           devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
         end
end
# def skip_session
#         request.session_options[:skip] = true
#        end
# skip_forgery_protection
#         protect_from_forgery with: :exception
#         before_action :skip_session
#         skip_before_action :verify_authenticity_token, if: :devise_controller?
