Rails.application.routes.draw do
  get 'storages/index'
  get 'storages/show'
  get 'storages/new'
  get 'storages/create'
  get 'storages/edit'
  get 'storages/update'
  get 'storages/destroy'
  get 'pages/home'
  devise_for :users
  root to: "pages#home"


  resources :storages do
    resources :wines, only: [:new, :create, :edit, :update, :show]
  end

  get "history", to: "wines#history"
end
