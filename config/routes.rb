Rails.application.routes.draw do
  namespace :admin do
    get 'customers/index'
    get 'customers/show'
    get 'customers/edit'
  end
  namespace :admin do
    get 'items' => "items#index", as: "items"
    resources :items, only: [:new, :create, :show, :edit, :update]
    resources :customers, only: [:index, :show, :edit, :update]
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
