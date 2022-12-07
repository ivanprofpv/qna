Rails.application.routes.draw do

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

  resources :questions, shallow: true, concerns: [:votable, :commentable] do
    resources :answers, shallow: true, except: :index, concerns: [:votable, :commentable] do
      member do
        patch :best
      end
    end
  end

  resources :attachments, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :awards, only: %i[index]

  mount ActionCable.server => '/cable'
end
