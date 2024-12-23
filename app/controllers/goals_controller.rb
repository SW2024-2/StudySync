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
    calculate_progress_for_goals(@todays_goals, 'today')
    calculate_progress_for_goals(@this_weeks_goals, 'this_week')
    calculate_progress_for_goals(@this_months_goals, 'this_month')
  end

  def new
    @goal = Goal.new
  end

  def create
    @report = Report.find(params[:report_id])
    @goal = @report.goals.new(goal_params)
    @goal.user = current_user
  
    # 学習時間を時間と分を合計して保存
    if @goal.save
      redirect_to report_goals_path(@report), notice: '目標が作成されました'
    else
      render :new, alert: '目標の作成に失敗しました'
    end
  end




  def edit
  end

  def update
    # 時間と分を合計して学習時間を計算
    total_study_time = (@goal.study_time_hours.to_i * 60) + @goal.study_time_minutes.to_i

    # 学習時間を更新
    if @goal.update(goal_params.merge(study_time: total_study_time))
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
  params.require(:goal).permit(:title, :study_time_hours, :study_time_minutes, :period, subject_ids: [])
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

  def calculate_total_study_time(hours, minutes)
    # 時間と分を合計して分に変換
    (hours * 60) + minutes
  end

  def calculate_progress_for_goals(goals, period)
    goals.each do |goal|
      goal_progress = calculate_progress(goal, period)
      goal.instance_variable_set(:@progress, goal_progress)
    end
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