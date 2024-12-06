class GoalsController < ApplicationController
  before_action :authenticate_user!

  def new
    @goal = Goal.new
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.user = current_user  # 現在のユーザーに関連付ける

    if @goal.save
      redirect_to reports_path, notice: "目標を設定しました"
    else
      render :new
    end
  end

  def edit
    @goal = current_user.goal
  end

  def update
    @goal = current_user.goal

    if @goal.update(goal_params)
      redirect_to reports_path, notice: "目標を更新しました"
    else
      render :edit
    end
  end
  
  def current_user
    User.find_by(id: session[:login_uid])  # session[:login_uid]がログインユーザーのIDである前提
  end

  private

  def authenticate_user!
    if current_user.nil?
      redirect_to login_path, alert: "ログインしてください"
    end
  end

  def goal_params
    params.require(:goal).permit(:target_time)  # target_time: 目標時間
  end
end
