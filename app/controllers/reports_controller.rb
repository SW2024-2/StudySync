class ReportsController < ApplicationController
  before_action :set_user
  before_action :redirect_if_not_logged_in
  before_action :set_study_times, only: :index

  def index
    # ユーザーのレポートを取得（ユーザーごとに関連付けられたレポートを取得）
    @report = Report.find_or_create_by(user_id: @user.id) do |report|
      report.title = "デフォルトのタイトル" # 必要なデフォルト値を指定
      report.study_time = 0                # 初期値
    end

    # ユーザーの目標一覧
    @goals = @report.goals
    @goal = Goal.new                     # 新規目標作成用の空のGoalオブジェクト
    @current_goal = @goals.first         # 最新の目標
    @study_time = @current_goal&.study_time || 0 # 最新の目標の学習時間
  end

  private

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
