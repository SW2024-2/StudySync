require "bcrypt"
class TopController < ApplicationController
  # トップページ（ログイン状態に応じて表示内容を切り替え）
  def main
    if session[:login_uid] # ログイン中かチェック
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
  
    if user && user.authenticate(params[:password]) # `authenticate` メソッドを使用して検証
      reset_session
      session[:login_uid] = user.id
      redirect_to study_logs_path, notice: "ログインに成功しました。"
    else
      flash.now[:alert] = "ユーザーIDまたはパスワードが間違っています。"
      render :error, status: :unprocessable_entity
    end
  end


  # ログアウト処理
  def logout
    reset_session # セッションを完全にリセット
    redirect_to login_form_path, notice: 'ログアウトしました' # ログイン画面にリダイレクト
  end
end
