Rails.application.routes.draw do
  root "home#index"

  # Clientes (ruta show agregada para consistencia de patron Jakob)
  get "clientes", to: "customers#index", as: :clientes
  get "clientes/new", to: "customers#new", as: :new_cliente
  post "clientes", to: "customers#create"
  get "clientes/:id", to: "customers#show", as: :cliente
  get "clientes/:id/edit", to: "customers#edit", as: :edit_cliente
  patch "clientes/:id", to: "customers#update"
  delete "clientes/:id", to: "customers#destroy"

  # Autos
  resources :cars, except: :show, path: "autos"

  # Servicios y Mecánicos (show agregado a mecanicos para consistencia Jakob)
  resources :services, except: :show, path: "servicios"
  resources :mechanics, path: "mecanicos"

  # Órdenes de Trabajo y sus detalles de servicios anidados (100% Rails puro)
  resources :orders, path: "ordenes" do
    member do
      patch :update_status
    end
    resources :order_details, only: %i[create destroy], path: "servicios"
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
