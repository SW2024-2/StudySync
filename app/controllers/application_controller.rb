class ApplicationController < ActionController::Base
  helper_method :current_user  # ビューでも使えるようにする

  def current_user
    # セッションにユーザーIDがあれば、ログイン中のユーザーを取得
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    # ユーザーがログインしているか確認
    !!current_user
  end

  def authenticate_user!
    # ログインしていない場合はログイン画面にリダイレクト
    unless logged_in?
      redirect_to login_form_path, alert: 'ログインしてください。'
    end
  end
end
