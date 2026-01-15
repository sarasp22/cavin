Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :storages do
    resources :wines, only: [:new, :create, :edit, :update, :show, :destroy]
  end

  get "history", to: "wines#history"

  get "up" => "rails/health#show", as: :rails_health_check
end
