Rails.application.routes.draw do

  devise_for :users

  resources :questions, shallow: true do
    resources :answers, shallow: true, except: :index do
      member do
        patch :best
      end
    end
  end

  resources :attachments, only: %i[destroy]
  resources :links, only: %i[destroy]

  root to: 'questions#index'
end
