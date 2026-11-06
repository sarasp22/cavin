Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check

  # Rotte PWA per installazione come App nativa su Android e iPhone
  get "pwa-manifest.json", to: "pages#manifest", as: :pwa_manifest
  get "pwa-sw.js", to: "pages#service_worker", as: :pwa_service_worker
  get "pwa-icon-192.png", to: "pages#icon_192", as: :pwa_icon_192
  get "pwa-icon-512.png", to: "pages#icon_512", as: :pwa_icon_512
  get "pwa-apple-icon.png", to: "pages#icon_180", as: :pwa_apple_icon

  get "sommelier", to: "sommelier#index", as: :sommelier
  post "api/sommelier/recommend", to: "sommelier#recommend", as: :sommelier_recommend

  resources :storages do
    resources :wines, only: [:new, :create, :show, :edit, :update, :destroy] do
      member do
        get :consume
        patch :mark_consumed
      end
    end
  end

  get "history", to: "wines#history", as: :history
  resources :wine_templates, only: [:index, :destroy]
end
