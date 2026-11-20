Rails.application.routes.draw do
  resources :cars, except: :show
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
  get "clientes", to: "customers#index", as: :clientes
  get "clientes/new", to: "customers#new", as: :new_cliente
  post "clientes", to: "customers#create"
  get "clientes/:id/edit", to: "customers#edit", as: :edit_cliente
  patch "clientes/:id", to: "customers#update", as: :cliente
  delete "clientes/:id", to: "customers#destroy"
end
