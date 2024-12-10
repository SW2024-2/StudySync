class GoalsController < ApplicationController
  before_action :set_report, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :set_goal, only: [:edit, :update, :destroy]

  def index
    today = Date.today
    start_of_week = today.beginning_of_week
    end_of_week = today.end_of_week
    start_of_month = today.beginning_of_month
    end_of_month = today.end_of_month

    # 今日の目標
    @todays_goals = Goal.where(user: current_user, period: 'daily')

    # 今週の目標
    @this_weeks_goals = Goal.where(user: current_user, period: 'weekly')

    # 今月の目標
    @this_months_goals = Goal.where(user: current_user, period: 'monthly')

    # 各目標の進捗度を計算して、進捗度を渡す
    @todays_goals.each do |goal|
      goal_progress = calculate_progress(goal, 'today')
      goal.instance_variable_set(:@progress, goal_progress)
    end

    @this_weeks_goals.each do |goal|
      goal_progress = calculate_progress(goal, 'this_week')
      goal.instance_variable_set(:@progress, goal_progress)
    end

    @this_months_goals.each do |goal|
      goal_progress = calculate_progress(goal, 'this_month')
      goal.instance_variable_set(:@progress, goal_progress)
    end
  end

  def new
    @goal = Goal.new
  end

  def create
    if @report.nil?
      @report = current_user.reports.create(title: "新しいレポート")
    end
    @goal = @report.goals.new(goal_params)
    @goal.user = current_user

    if @goal.save
      redirect_to report_goals_path(@report), notice: '目標が作成されました'
    else
      render :new
    end
  end

  def edit
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
    params.require(:goal).permit(:title, :study_time, :period)  # period を追加
  end

  def set_report
    if params[:report_id]
      @report = current_user.reports.find_by(id: params[:report_id])
    else
      @report = current_user.reports.create(title: "新しいレポート")
    end
  end

  def set_goal
    @goal = @report.goals.find(params[:id]) if @report
  end

def calculate_progress(goal, period)
  total_study_time = case period
  when 'today'
    StudyLog.study_time_today(current_user)[goal.title] || 0
  when 'this_week'
    StudyLog.study_time_this_week(current_user)[goal.title] || 0
  when 'this_month'
    StudyLog.study_time_this_month(current_user)[goal.title] || 0
  else
    0
  end

  return 0 if goal.study_time == 0  # 目標時間が0の場合、進捗は0%
  (total_study_time.to_f / goal.study_time.to_f) * 100
end


  
    # 現在のユーザーを取得
  def current_user
    @current_user ||= User.find_by(id: session[:login_uid])
  end
end
