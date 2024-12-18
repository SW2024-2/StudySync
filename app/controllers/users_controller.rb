class UsersController < ApplicationController
  # new: 新規ユーザー登録画面を表示するアクション
  def new
    @user = User.new
  end

  # create: フォームから送信されたデータを基にユーザーを作成するアクション
  def create
    if User.find_by(uid: params[:user][:uid])
      flash[:alert] = "指定されたユーザーIDは既に存在しています。"
      redirect_to new_user_path
    else
      @user = User.new(user_params)
  
      if @user.save
        redirect_to root_path, notice: "登録が完了しました。" 
      else
        flash.now[:alert] = "登録に失敗しました。入力内容を確認してください。"
        render :new, status: :unprocessable_entity
      end
    end
  end


  private

  # ストロングパラメータ
  def user_params
    # `password` と `password_confirmation` を許可して、`has_secure_password` が自動的に処理する
    params.require(:user).permit(:name, :email, :uid, :password, :password_confirmation)
  end
end
