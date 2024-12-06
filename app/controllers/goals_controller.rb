class GoalsController < ApplicationController
  before_action :authenticate_user!  # ログインしていない場合はログイン画面にリダイレクト

  def new
    @goal = Goal.new
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.user = current_user  # current_user を使用してユーザーを設定

    if @goal.save
      redirect_to reports_path, notice: '目標が設定されました'
    else
      render :new
    end
  end

  def edit
    @goal = Goal.find(params[:id])
  end

  def update
    @goal = Goal.find(params[:id])
    if @goal.update(goal_params)
      redirect_to reports_path, notice: '目標が更新されました'
    else
      render :edit
    end
  end

  def destroy
    @goal = Goal.find(params[:id])
    @goal.destroy
    redirect_to reports_path, notice: '目標が削除されました。'
  end

  private

  def goal_params
    params.require(:goal).permit(:target_time)
  end
end
