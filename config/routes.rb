Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
    end
  end
  post "rails/active_storage/direct_uploads", to:'direct_uploads#create'
  put  "rails/active_storage/direct_uploads", to: "direct_uploads#update"
  delete "rails/active_storage/direct_uploads", to: "direct_uploads#destroy"
end
