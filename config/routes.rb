Rails.application.routes.draw do
  # トップページを study_logs#index に設定
  root 'study_logs#index'

  # ログイン関連
  get 'login', to: 'top#login_form', as: :login_form
  post 'login', to: 'top#login', as: :login
  get 'logout', to: 'top#logout', as: :logout

  # ヘルスチェック用ルート
  get "up", to: "rails/health#show", as: :rails_health_check

  # リソース関連
  resources :users, only: [:new, :create, :edit, :update, :destroy]
  
  # コメントの一覧、作成、削除を許可
  resources :study_logs do
    resources :comments, only: [:index, :create, :destroy]
  end
  
  resources :reports do
    resources :goals
  end

  resources :likes, only: [:create, :destroy]
  
  resources :friendships, only: [:index, :create, :destroy] do
    collection do
      get 'search' # 検索機能用のルート
    end
  end
  
  # その他の個別ルート（不要）
  # 以下の個別ルートは削除できます
  # get 'study_logs/show'
  # get 'study_logs/new'
  # get 'study_logs/create'
  # get 'study_logs/edit'
  # get 'study_logs/update'
  # get 'study_logs/destroy'
  # get 'users/show'
  # get 'users/edit'
  # get 'users/update'
  # get 'users/destroy'
  # get 'reports/index'
  # get 'reports/show'
  # get 'comments/create'
  # get 'comments/destroy'
  # get 'likes/create'
  # get 'likes/destroy'
end
