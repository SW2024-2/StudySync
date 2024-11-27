class UsersController < ApplicationController
  # new: 新規ユーザー登録画面を表示するアクション
  def new
    @user = User.new
  end

  # create: フォームから送信されたデータを基にユーザーを作成するアクション
  def create
  # パスワードをハッシュ化
  user_pass = BCrypt::Password.create(params[:user][:password])

  if User.exists?(uid: params[:user][:uid])
    flash[:alert] = "指定されたユーザーIDは既に存在しています。"
    redirect_to new_user_path
  else
    user = User.new(
      uid: params[:user][:uid],
      name: params[:user][:name],
      email: params[:user][:email],
      password_digest: user_pass # パスワードのハッシュを保存
    )

    if user.save
      redirect_to root_path, notice: "登録が完了しました。" # 登録後、トップページにリダイレクト
    else
      flash.now[:alert] = "登録に失敗しました。入力内容を確認してください。"
      render :new, status: :unprocessable_entity
    end
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
      flash.now[:alert] = "更新に失敗しました。入力内容を確認してください。"
      render :edit, status: :unprocessable_entity
    end
  end

  # destroy: ユーザーを削除するアクション
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path, notice: "ユーザーが削除されました。"
  end

 private

  # ストロングパラメータ
  def user_params
    params.require(:user).permit(:name, :email, :uid, :password, :password_confirmation)
  end
end