Rails.application.routes.draw do
  get "categories/show"
  get "pages/show"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
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

  # 添加购物车路由
  get '/cart', to: 'carts#show', as: 'cart'

  # 购物车路由 - 定义添加到购物车的路径
  post 'cart/add/:id', to: 'carts#add', as: 'add_to_cart'

  # 购物车路由
  delete 'cart', to: 'carts#clear', as: 'clear_cart'  # 清空购物车
  delete 'cart/:id', to: 'carts#remove', as: 'remove_from_cart'  # 从购物车中移除商品

  root to: 'products#index'

end
