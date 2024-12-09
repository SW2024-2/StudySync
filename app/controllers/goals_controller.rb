class GoalsController < ApplicationController
  before_action :set_report, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :set_goal, only: [:edit, :update, :destroy] # edit と update の前に goal をセット

  def index
    # 今日、今週、今月の目標を期間別に取得
    @todays_goals = current_user.goals.where(period: 'daily')
    @this_weeks_goals = current_user.goals.where(period: 'weekly')
    @this_months_goals = current_user.goals.where(period: 'monthly')
  end

  def new
    @goal = Goal.new
    # @report は before_action で設定されるため、ここで再設定は不要です
  end

  def create
    @goal = @report.goals.new(goal_params)
    @goal.user = current_user
  
    if @goal.save
      redirect_to report_goals_path(@report), notice: '目標が作成されました'
    else
      render :new
    end
  end

  def edit
    # ここで @goal は set_goal で設定されている
  end

  def update
    if @goal.update(goal_params)
      redirect_to report_goals_path(@goal.report), notice: '目標が更新されました。'
    else
      render :edit
    end
  end
  
  def destroy
    @goal.destroy
    redirect_to report_goals_path(@report), notice: '目標が削除されました。'
  end

  private

  def goal_params
    params.require(:goal).permit(:title, :study_time, :period)
  end

  def current_user
    @current_user ||= User.find_by(id: session[:login_uid])
  end

  def set_report
    if params[:report_id]
      @report = current_user.reports.find_by(id: params[:report_id])
    else
      @report = current_user.reports.first
    end
    redirect_to reports_path, alert: 'レポートが見つかりませんでした。' unless @report
  end

  def set_goal
    @goal = @report.goals.find(params[:id]) if @report
  end
end
