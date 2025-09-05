Rails.application.routes.draw do
  # articles and comments routes
  #comment is nested under articles
  namespace :post do
    resources :articles do
        resources :comments, only: [:create, :destroy, :index]
        # resources :likes, only: [:create, :destroy]
        post 'like', to: 'likes#create'
        delete 'unlike', to: 'likes#destroy'
    end
  end
  
  # default User authentication routes.
  devise_for :users, path: '', path_names: {
  sign_in: 'login',
  sign_out: 'logout',
  registration: 'signup'
  },

  # custom
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    delete 'account', to: 'users/sessions#destroy_account'
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
