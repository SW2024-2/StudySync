Rails.application.routes.draw do
  get 'friendships/create'
  get 'friendships/destroy'
  get 'study_logs/index'
  resources :study_logs, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :friendships, only: [:index, :create, :destroy]
  resources :reports, only: [:index, :show]
  
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
  get 'reports/index'
  get 'reports/show'
  get 'comments/create'
  get 'comments/destroy'
  get 'likes/create'
  get 'likes/destroy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # 各リソースに必要なアクションを指定
  resources :reports, only: [:index, :show]
  resources :comments, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]
  resources :friendships, only: [:create, :destroy]
  resources :study_logs # 全てのCRUD操作を含む
  resources :users, only: [:new, :create, :show, :edit, :update, :destroy]

  # トップページとログイン関連
  root 'top#main'
  get 'login', to: 'top#login_form', as: :login_form # ログイン画面表示用
  get 'login', to: 'top#login_form', as: :login_form # ログイン画面表示用
  post 'login', to: 'top#login', as: :login          # ログイン処理用          
  delete 'logout', to: 'top#logout', as: :logout
  get 'users/error'

  # ヘルスチェック用ルート
  get "up", to: "rails/health#show", as: :rails_health_check
end
