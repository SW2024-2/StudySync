class ReportsController < ApplicationController
  before_action :set_user
  before_action :set_study_times, only: :index

  def index
    @report = current_user.reports.last
    @goals_today = current_user.goals.today.order(created_at: :desc).first
    @goals_this_week = current_user.goals.this_week.order(created_at: :desc).first
    @goals_this_month = current_user.goals.this_month.order(created_at: :desc).first

    # 今日、今週、今月の進捗度を計算
    @progress_today = calculate_progress(@goals_today, @todays_study_time)
    @progress_this_week = calculate_progress(@goals_this_week, @this_weeks_study_time)
    @progress_this_month = calculate_progress(@goals_this_month, @this_months_study_time)
  end

  private

  # ユーザー設定
  def set_user
    @user = current_user
    redirect_to login_path, alert: "ログインしてください。" unless @user
  end

  # 学習時間の設定
  def set_study_times
    @todays_study_time = sum_study_time(StudyLog.study_time_today(@user))
    @this_weeks_study_time = sum_study_time(StudyLog.study_time_this_week(@user))
    @this_months_study_time = sum_study_time(StudyLog.study_time_this_month(@user))
    @total_study_time = sum_study_time(StudyLog.total_study_time(@user))
  end

  # ハッシュの学習時間を合計するメソッド
  def sum_study_time(study_time_hash)
    return 0 unless study_time_hash.is_a?(Hash)
    study_time_hash.values.sum
  end

  # 進捗度を計算するメソッド
  def calculate_progress(goal, study_time)
    return 0 unless goal && study_time > 0

    # 目標に対する学習時間を取得
    total_study_time_for_goal = StudyLog.total_study_time_for_goal(@user, goal) || 0
    
    # 進捗度計算（進捗度は最大100%に制限）
    progress_percentage = (total_study_time_for_goal.to_f / goal.study_time) * 100
    [progress_percentage, 100].min.round(2)
  end

  # 現在のユーザーを取得
  def current_user
    @current_user ||= User.find_by(id: session[:login_uid])
  end
end
