Rails.application.routes.draw do
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
  post 'login', to: 'top#login', as: :login          # ログイン処理用
  delete 'logout', to: 'top#logout', as: :logout
  get 'users/error'

  # ヘルスチェック用ルート
  get "up", to: "rails/health#show", as: :rails_health_check
end
