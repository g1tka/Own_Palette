Rails.application.routes.draw do

  devise_for :admins, controllers: {
    sessions: 'admin/sessions'
  }
  devise_for :users, controllers: {
    registrations: 'user/registrations',
    sessions: 'user/sessions'
  }

  root :to => 'homes#top'
  get '/about' => 'homes#about'

  scope module: :user do
    get '/search' => 'searches#index'
    get '/search' => 'searches#search'
    
    resources :posts do
      collection do
        get 'search', to: 'posts#search', as: 'search'
      end
      resource :favorites, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy] do
        collection do
          post 'filter'
        end
      end
    end
    
    resources :users, only: [:show, :edit, :update] do
      member do
        get 'unsubscribe'
        patch 'withdraw'
      end
      get 'relationships/search' => 'relationships#search', as: :search_relationships
      resources :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
    end
  end

  namespace :admin do
    resources :posts, only: [:index, :show, :update, :destroy] do
      member do
        patch 'toggle_status'
        delete 'comments/:comment_id', to: 'comments#destroy_comment', as: :destroy_comment
      end
    end
    resources :users, only: [:index, :show, :update] do
      member do
        patch 'user_ban'
      end
    end
    resources :comments, only: [:index, :update, :destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
