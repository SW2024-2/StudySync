class TopController < ApplicationController
  # トップページ（ログイン状態に応じて表示内容を切り替え）
  def main
    if session[:login_uid]
      redirect_to tweets_path, notice: "既にログインしています。" # 適切なリダイレクト先を指定
    else
      render "login" # 未ログインの場合はログイン画面を表示
    end
  end

  # ログイン処理
  def login
    user = User.find_by(uid: params[:uid])
    if user && BCrypt::Password.new(user.password_digest).is_password?(params[:password])
      session[:login_uid] = user.uid
      redirect_to top_main_path, notice: "ログインに成功しました。"
    else
      flash.now[:alert] = "ユーザーIDまたはパスワードが間違っています。"
      render :main, status: 422
    end
  end

  # ログアウト処理
  def logout
    session.delete(:login_uid)
    redirect_to root_path, notice: "ログアウトしました。"
  end
end
