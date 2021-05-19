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
          get :draft_search
          get :follows
          get :followers
          get :time_line
        end
        collection do
          get :search
        end
      end
      resources :draft_learns do
        collection do
          get :todays_task
          get :past_tasks
        end
      end
      resources :learns do
        collection do
          get :todays_task
          get :past_tasks
        end
      end
      resources :relationships,only:[:create,:destroy]
      resources :likes,only:[:create]
      delete "likes", to: "likes#destroy"
    end
  end
  post   "rails/active_storage/direct_uploads", to:'direct_uploads#create'
  put    "rails/active_storage/direct_uploads", to: "direct_uploads#update"
  delete "rails/active_storage/direct_uploads", to: "direct_uploads#destroy"
end
