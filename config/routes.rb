require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  root to: 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  post 'users/confirmation', to: 'users#confirm_email'

  concern :votable do
    member do
      post :like
      post :dislike
    end
  end

  concern :commentable do
    resources :comments, shallow: true, only: %i[create]
  end

  resources :questions, shallow: true, concerns: %i[votable commentable] do
    resources :answers, shallow: true, except: :index, concerns: %i[votable commentable] do
      member do
        patch :best
      end
    end
    resources :subscriptions, shallow: true, only: %i[create destroy]
  end

  resources :attachments, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :awards, only: %i[index]

  get :search, to: 'search#index'

  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index] do
        get :me, on: :collection
      end
      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only: %i[index show update create destroy]
      end
    end
  end
end
