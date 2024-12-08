class ReportsController < ApplicationController
  before_action :set_user
  before_action :redirect_if_not_logged_in
  before_action :set_study_times, only: :index

  def index
    @report = current_user.reports.last  # 例: ユーザーに関連する最新のレポートを取得

    # @reportがnilの場合は空の配列を設定
    if @report
      @goals = @report.goals
    else
      @goals = []  # レポートが存在しない場合は空の配列
    end

    @current_goal = Goal.find_by(user_id: current_user.id)  # ユーザーに関連する目標を取得

    # 目標がない場合は0を設定
    @study_time = @current_goal ? @current_goal.study_time || 0 : 0

    @goal = Goal.new  # 新規目標作成用の空のGoalオブジェクト
  end

  def create_goal
    @goal = Goal.new(goal_params)
    @goal.user = current_user  # 現在のユーザーを関連付け

    # レポートが存在しない場合、新しく作成する
    @goal.report = current_user.reports.last || current_user.reports.create

    if @goal.save
      redirect_to report_path(@goal.report), notice: '目標が作成されました。'
    else
      render :new, alert: '目標の作成に失敗しました。'
    end
  end

  private

  def goal_params
    params.require(:goal).permit(:title, :study_time)
  end

  def set_user
    @user = current_user
  end

  def redirect_if_not_logged_in
    redirect_to login_path, alert: "ログインしてください。" if @user.nil?
  end

  def set_study_times
    @todays_study_time = format_subject_times(StudyLog.study_time_today(@user))
    @this_weeks_study_time = format_subject_times(StudyLog.study_time_this_week(@user))
    @this_months_study_time = format_subject_times(StudyLog.study_time_this_month(@user))
    @total_study_time = StudyLog.total_study_time(@user)
  end

  def format_subject_times(subject_times)
    subject_times || {}
  end

  def current_user
    @current_user ||= User.find_by(id: session[:login_uid]) # session[:login_uid]がログインユーザーのID
  end
end
