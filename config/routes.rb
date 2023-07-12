Rails.application.routes.draw do
  namespace :admin do
    root to: 'homes#top'
    get 'items' => "items#index", as: "items"
    resources :items, only: [:new, :create, :show, :edit, :update]
    resources :customers, only: [:index, :show, :edit, :update]
    resources :orders, only: [:show, :update]
    resources :order_items, only: [:update]
  end

  scope module: :public do
    root to: 'homes#top'
    get "about" => "homes#about", as: "about"
    resource :customers, only: [:show, :update] do
      get "information/edit" => "customers#edit",as: "edit"
      get "unsubscribe" => "customers#unsubscribe", as: "unsubscribe"
      patch "withdraw" => "customers#withdraw", as: "withdraw"
    end
    resources :items, only: [:index, :show]
    delete "cart_items/destroy_all" => "cart_items#destroy_all", as: "destroy_all"
    resources :cart_items, only: [:index, :create, :update, :destroy]
    resources :orders, only: [:new, :create, :index, :show] do
      collection do
        post "check" => "orders#check", as: "check"
        get "complete" => "orders#complete", as: "complete"
      end
    end
  end
  devise_for :admin, controllers: {
    sessions:      'admin/sessions',
    passwords:     'admin/passwords',
    registrations: 'admin/registrations'
  }
  devise_for :customers, controllers: {
    sessions:      'public/sessions',
    passwords:     'public/passwords',
    registrations: 'public/registrations'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
