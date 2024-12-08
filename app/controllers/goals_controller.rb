class GoalsController < ApplicationController
  before_action :set_report
  before_action :set_goal, only: [:edit, :update, :destroy]

  def new
    @goal = @report.goals.new
  end

  def create
    @goal = @report.goals.new(goal_params)
    @goal.user = current_user  # Associate the goal with the logged-in user

    if @goal.save
      redirect_to reports_path, notice: "目標が作成されました。"
    else
      flash.now[:alert] = "目標の作成に失敗しました。"
      render :new
    end
  end

  def edit
    # `set_goal`で処理済み
  end

  def update
    if @goal.update(goal_params)
      redirect_to reports_path, notice: "目標が更新されました。"
    else
      flash.now[:alert] = "目標の更新に失敗しました。"
      render :edit
    end
  end

  def destroy
    @report = Report.find(params[:report_id])
    @goal = @report.goals.find(params[:id])
    @goal.destroy
    redirect_to report_path(@report), notice: '目標が削除されました。'
  end
  end

  private

  def set_report
    @report = Report.find(params[:report_id])
  end

  def set_goal
    @goal = @report.goals.find(params[:id])
  end

  def goal_params
    params.require(:goal).permit(:study_time)
  end

  def current_user
    @current_user ||= User.find_by(id: session[:login_uid]) # session[:login_uid]がログインユーザーのID
  end

  def authenticate_user
    unless current_user
      redirect_to login_path, alert: "ログインしてください。"
  end
end
