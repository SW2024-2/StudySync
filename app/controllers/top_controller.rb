class TopController < ApplicationController
  # トップページ（ログイン状態に応じて表示内容を切り替え）
  def main
    if session[:current_user_id]  # ログイン中かチェック
      redirect_to study_logs_path, notice: "既にログインしています。"
    else
      redirect_to login_form_path
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
      session[:current_user_id] = user.id  # セッションにユーザーIDを保存
      redirect_to study_logs_path, notice: "ログインに成功しました。"
    else
      flash.now[:alert] = "ユーザーIDまたはパスワードが間違っています。"
      render 'login', status: 422  # ログインフォームに戻す
    end
  end

  # ログアウト処理
  def logout
    session.delete(:current_user_id)  # セッションからユーザーIDを削除
    redirect_to login_form_path, notice: 'ログアウトしました'  # ログイン画面にリダイレクト
  end



end