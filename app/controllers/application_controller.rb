class ApplicationController < ActionController::Base
  helper_method :current_user , :logged_in? # ビューでも使えるようにする

  def current_user
    # セッションにユーザーIDがあれば、ログイン中のユーザーを取得
    #session[:user_id]をsession[:login_uid]に変更
    @current_user ||= User.find_by(id: session[:login_uid])if session[:login_uid]
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
