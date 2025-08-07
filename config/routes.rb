# config/routes.rb
Rails.application.routes.draw do
  devise_for :users

  resources :file_uploads do
    member do
      get :download
    end
  end

  # ✅ Public share route
  get '/f/:share_token', to: 'file_uploads#public_view', as: :public_file

  root "file_uploads#index"
end
