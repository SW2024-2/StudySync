class TopController < ApplicationController
  # トップページ（ログイン状態に応じて表示内容を切り替え）
  def main
    if session[:login_uid]
      redirect_to study_logs_path, notice: "既にログインしています。" # 学習記録の一覧ページへリダイレクト
    else
      redirect_to login_form_path # 未ログインの場合はログイン画面へリダイレクト
    end
  end

  # ログイン画面表示
  def login_form
    render :login
  end

  # ログイン処理
  def login
    user = User.find_by(uid: params[:uid])
    if user && BCrypt::Password.new(user.password_digest).is_password?(params[:password]) # 正しいパスワードチェック
      session[:login_uid] = user.uid
      redirect_to study_logs_path, notice: "ログインに成功しました。"
    else
      flash.now[:alert] = "ユーザーIDまたはパスワードが間違っています。"
      render 'error', status: 422
    end
  end


  # ログアウト処理
  def logout
    session.delete(:login_uid)
    redirect_to login_form_path, notice: "ログアウトしました。"
  end
end