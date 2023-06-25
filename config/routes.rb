Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
    registrations: 'admins/registrations'
  }
  devise_for :customers, controllers: {
    sessions:      'public/sessions',
    passwords:     'public/passwords',
    registrations: 'public/registrations'
  }
  scope module: :public do
    root to: 'homes#top'
    get "about" => "homes#about", as: "about"
    resource :customers, only: [:show, :update] do
      get "information/edit" => "customers#edit",as: "edit"
      get "unsubscribe" => "customers#unsubscribe", as: "unsubscribe"
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
