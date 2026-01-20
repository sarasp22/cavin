Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :storages do
    resources :wines, only: [:new, :create, :edit, :update, :show, :destroy] do
      member do
        get :consume
        patch :mark_consumed
      end
    end
  end

  resources :wine_templates, only: [:index, :create, :destroy]

  get "history", to: "wines#history"

  get "up" => "rails/health#show", as: :rails_health_check
end
