Rails.application.routes.draw do
  devise_for :users,
    controllers: {
      sessions: 'api/v1/user_sessions',
      registrations: 'api/v1/user_registrations'
    }

  namespace :api do
    namespace :v1 do
      resources :locations, only: [ :index, :show ] do
        member do
          get :list_by_location
        end
      end

      resources :users, only: [ :show, :update ] do
        member do
          post :update_password
          patch :follow
          delete :unfollow
          patch :block
          get :list_by_user
        end

        collection do
          get :blocked_list
          patch :unblock_users
          get :timeline
        end
      end

      resources :abuses, only: [ :index, :create ] do
        collection do
          get :handle_abuses
        end
      end

      resources :micro_blogs, only: [ :create, :show, :update, :destroy ] do
        member do
          get :list_by_micro_blog
        end
      end

      resources :likes, only: [ :destroy ] do
        collection do
          get :create
        end
      end

      resources :comments, only: [ :create, :update, :destroy ]

      resources :shares, only: [ :create, :show, :update, :destroy ] do
        member do
          get :list_by_share
        end
      end
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'swagger_docs#index'
end
