Rails.application.routes.draw do
  resources :recommendations
  resources :grader_schedules
  resources :section_schedules
  devise_for :users
  
  resources :sections
  
  # Naming a custom route for displaying /courses/(:id)
  resources :courses, except: [:show]
  get 'courses/:id', to: 'courses#decision'
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "home#index"

  #
  resources :grader_application
  post "grader_application/:id/update" => "grader_application#update"

  #
  resources :assigned_graders
  
  resources :admin, only: [:index, :edit]
  resources :request, only: [:index]
  post "request/:id/update" => "request#update"
  post "admin/:id/update" => "admin#update"
  #get '/admin/applications' => "admin#applications"
  
  #TODO: TEST THIS
  post "recommendations/:id" => "recommendations#destroy"

  #General error route that gets redirected to
  get 'error', to: 'error#show'
  
  #
  get 'notice', to: 'notice#show'
  
  #Grader application related
  get 'grader', to: 'grader#profile_show'
  get 'grader/app_edit', to: 'grader#app_show'
  put 'grader/app_edit', to: 'grader#app_submit'
  get 'grader/schedule_edit', to: 'grader#schedule_show'
  put 'grader/schedule_edit', to: 'grader#time_add'
  put 'grader/remove_time/:id', to: 'grader#time_delete'
  put 'grader/create_profile', to: 'grader#create_profile'
  
  #For editing the timeslots of a section
  get 'sections/:id/schedule_edit', to: 'section_schedules#index'
  post 'sections/:id/schedule_edit', to: 'section_schedules#create'
  put 'section_schedules/:id/delete', to: 'section_schedules#destroy'
  
  #Route for admin to assign graders
  get 'assign_graders', to: 'grader_application#needed_sections'
  get 'assign_graders/:section_id/select_grader', to: 'grader_application#eligible_graders'
  get 'assign_graders/:section_id/select_grader/:grader_id', to: 'grader_application#actual_assignment'

end
