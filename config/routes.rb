Rails.application.routes.draw do
  get "pages/show"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  # Pages routes
  get '/pages/:slug', to: 'pages#show', as: 'page'

  # Set about and contact page routes
  get '/about', to: 'pages#show', defaults: { slug: 'about' }
  get '/contact', to: 'pages#show', defaults: { slug: 'contact' }


  # Add resources for products
  resources :products, only: [:index, :show, :new, :create]
  resources :categories, only: [:show]

  # 统一使用 carts 控制器
  resource :cart, only: [:show]
  post 'cart/add/:id', to: 'carts#add', as: 'add_to_cart'
  patch 'cart/update/:id', to: 'carts#update', as: 'update_cart'
  delete 'cart/remove/:id', to: 'carts#remove', as: 'remove_from_cart'
  delete 'cart/clear', to: 'carts#clear', as: 'clear_cart'

  resources :orders, only: [:index, :show, :new, :create] do
    get 'success', on: :member
    get 'cancel', on: :member
  end

  # Stripe webhook
  post 'stripe/webhook', to: 'stripe#webhook'

  # Add my account route
  get '/my_account', to: 'users#show', as: 'my_account'

  root to: 'products#index'

end
