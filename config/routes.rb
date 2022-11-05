Rails.application.routes.draw do
  
  devise_for :users

  resources :questions, shallow: true do
    resources :answers, shallow: true, except: :index do 
      member do 
        patch :best
      end
    end
  end

  root to: 'questions#index'
end
