Rails.application.routes.draw do
  namespace :admin do
    get 'comments/index'
  end
  namespace :admin do
    get 'users/index'
    get 'users/show'
  end
  namespace :admin do
    get 'posts/index'
    get 'posts/show'
  end
  namespace :user do
    get 'relationships/index'
  end
  namespace :user do
    get 'users/index'
    get 'users/unsubscribe'
  end
  namespace :user do
    get 'posts/index'
    get 'posts/new'
    get 'posts/show'
    get 'posts/edit'
  end
  get 'homes/top'
  get 'homes/about'
  devise_for :admins
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
