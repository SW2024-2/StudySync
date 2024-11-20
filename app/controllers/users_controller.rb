class UsersController < ApplicationController
  # new: 新規ユーザー登録画面を表示するアクション
  def new
    @user = User.new
  end

  # create: フォームから送信されたデータを基にユーザーを作成するアクション
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path, notice: "ユーザー登録が完了しました。ログインしてください。"
    else
      render :new
    end
  end

  # show: ユーザーのプロフィールページを表示するアクション
  def show
    @user = User.find(params[:id])
  end

  # edit: ユーザー情報を編集する画面を表示するアクション
  def edit
    @user = User.find(params[:id])
  end

  # update: ユーザー情報を更新するアクション
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: "ユーザー情報が更新されました。"
    else
      render :edit
    end
  end

  # destroy: ユーザーを削除するアクション
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path, notice: "ユーザーが削除されました。"
  end

  private

  def user_params
    params.require(:user).permit(:uid, :password, :password_confirmation)
  end
end
