Rails.application.routes.draw do
  # articles and comments routes
  #comment is nested under articles
  namespace :post do
    resources :articles do
        resources :comments, only: [:create, :destroy, :index]
        # resources :likes, only: [:create, :destroy]
        post "toggle_like", to: "likes#toggle"
    end
  end

  #admin
  namespace :admin do
    resources :users, only: [] do
      collection do
        get :pending
      end
      member do
        patch :approved
      end
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
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  devise_scope :user do
    delete 'users/deleteacc', to: 'users/sessions#destroy_account'
    patch 'users/change_password', to: 'users/registrations#change_password'
  end
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :users do 
    resource :profile, only: [:show, :update, :destroy]
    get '/profiles/:id', to: 'profiles#public'
  end
end
