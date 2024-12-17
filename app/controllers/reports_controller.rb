class ReportsController < ApplicationController
  before_action :set_user
  before_action :set_study_times, only: :index

  def index
    # 新しいレポートがなければ作成
    @report = current_user.reports.first
    unless @report
      @report = current_user.reports.create(title: "新しいレポート", user: current_user)
    end

    # 今日の学習時間を科目ごとに取得
    @todays_study_time = StudyLog.study_time_today(current_user)
    
    # 今週の学習時間を科目ごとに取得
    @this_weeks_study_time = StudyLog.study_time_this_week(current_user)
    
    # 今月の学習時間を科目ごとに取得
    @this_months_study_time = StudyLog.study_time_this_month(current_user)
    
    # 合計学習時間
    @total_study_time = StudyLog.total_study_time(current_user)
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
    # 目標が存在しない場合は進捗度を0に
    return 0 unless goal
    
    # 学習時間がゼロの場合は進捗度もゼロ
    return 0 if study_time == 0

    # 目標に対する学習時間を取得
    total_study_time_for_goal = StudyLog.total_study_time_for_goal(@user, goal) || 0
    
    # 目標に対して学習時間がゼロの場合は進捗度0
    return 0 if total_study_time_for_goal == 0

    # 進捗度計算（進捗度は最大100%に制限）
    progress_percentage = (total_study_time_for_goal.to_f / goal.study_time) * 100
    [progress_percentage, 100].min.round(2)
  end

  # 現在のユーザーを取得
  def current_user
    @current_user ||= User.find_by(id: session[:login_uid])
  end
end