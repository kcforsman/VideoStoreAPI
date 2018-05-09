Rails.application.routes.draw do

  post 'rentals/check-out', to: 'rentals#check_out', as: 'check_out'

  post 'rentals/check-in', to: 'rentals#check_in', as: 'check_in'

  get 'rentals/overdue', to: 'rentals#overdue', as: 'overdue'

  resources :customers, only: [:index] do
    resources :current, only: [:index]
    resources :history, only: [:index]
  end

  resources :movies, only: [:index, :show, :create] do
    resources :current, only: [:index]
    resources :history, only: [:index]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
