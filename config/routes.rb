Rails.application.routes.draw do
<<<<<<< HEAD
  get 'reports/index'
  get 'reports/show'
  get 'comments/create'
  get 'comments/destroy'
  get 'likes/create'
  get 'likes/destroy'
=======
  get 'friendships/create'
  get 'friendships/destroy'
  get 'study_logs/index'
  get 'study_logs/show'
  get 'study_logs/new'
  get 'study_logs/create'
  get 'study_logs/edit'
  get 'study_logs/update'
  get 'study_logs/destroy'
  get 'users/new'
  get 'users/create'
  get 'users/show'
  get 'users/edit'
  get 'users/update'
  get 'users/destroy'
>>>>>>> model_and_controller
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
