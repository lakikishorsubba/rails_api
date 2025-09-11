Rails.application.routes.draw do
  # articles and comments routes
 
  namespace :post do #namespace :post means all controllers inside app/controllers/post/
    resources :articles do  #comment is nested under articles (/post/articles/:article_id/comments )
        resources :comments, only: [:create, :destroy, :index]
        # resources :likes, only: [:create, :destroy]
        post "toggle_like", to: "likes#toggle" #custom route
    end
  end

  #admin
  namespace :admin do 
    resources :users, only: [] do #we dont want CRUD, just a custom rute.
      collection do # act on all user(no ingle ID)
        get :pending 
      end
      member do #act on one user(need ID)
        patch :approved
      end
    end
  end

  
  # devise_for :users automatically generates all authentication routes.
  devise_for :users, path: '', path_names: { # path: '', path_names: remove the default route and rename.
  sign_in: 'login',
  sign_out: 'logout',
  registration: 'signup'
  },


  # custom controller to overrite Devise controller.
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  #devise_scope allows to define custom route.
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
