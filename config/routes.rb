Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/auth/registrations'
      }
      mount_devise_token_auth_for 'Admin', at: 'admin',controllers:{
        sessions: 'api/v1/admin/sessions'
      }
      resources :users do
        member do
          get :learn_search
          get :search
        end
      end
      resources :draft_learns do
        collection do
          get :todays_task
        end
      end
      resources :learns do
        collection do
          get :todays_task
        end
      end
    end
  end
  post   "rails/active_storage/direct_uploads", to:'direct_uploads#create'
  put    "rails/active_storage/direct_uploads", to: "direct_uploads#update"
  delete "rails/active_storage/direct_uploads", to: "direct_uploads#destroy"
end
