class ReportsController < ApplicationController
  before_action :set_user
  before_action :set_study_times, only: :index

  def index
    @report = current_user.reports.last
    @goals_today = current_user.goals.today.order(created_at: :desc)
    @goals_this_week = current_user.goals.this_week.order(created_at: :desc)
    @goals_this_month = current_user.goals.this_month.order(created_at: :desc)

    # 今日の目標を一番新しいものを設定
    @current_goal = @goals_today.first
    @study_time = @current_goal&.study_time || 0

    # 進捗度を計算
    if @current_goal && @study_time > 0
      total_study_time_for_goal = StudyLog.total_study_time_for_goal(@user, @current_goal)
      @progress_percentage = [(total_study_time_for_goal.to_f / @study_time) * 100, 100].min.round(2)
    else
      @progress_percentage = 0
    end
  end

  private

  # ユーザー設定
  def set_user
    @user = current_user
    redirect_to login_path, alert: "ログインしてください。" unless @user
  end

  # 学習時間の設定
  def set_study_times
    @todays_study_time = StudyLog.study_time_today(@user) || {}
    @this_weeks_study_time = StudyLog.study_time_this_week(@user) || {}
    @this_months_study_time = StudyLog.study_time_this_month(@user) || {}
    @total_study_time = StudyLog.total_study_time(@user)
  end

  # 現在のユーザーを取得
  def current_user
    @current_user ||= User.find_by(id: session[:login_uid])
  end
end
