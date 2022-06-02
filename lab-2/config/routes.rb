Rails.application.routes.draw do
  get 'catalogue/httpartyGet'
  devise_for :users
  
  resources :sections
  
  # Naming a custom route for displaying /courses/(:id)
  resources :courses, except: [:show]
  get 'courses/:id', to: 'courses#decision'
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "home#index"
  
  get 'user_list', to: 'user_list#show'
  #get 'catalog', to: 'courses#_form'

  resources :admin, only: [:index, :edit]
  resources :request, only: [:index]
  post "request/:id/update" => "request#update"
  post "admin/:id/update" => "admin#update"

  get 'error', to: 'error#show'
end
