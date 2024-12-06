class ReportsController < ApplicationController
  def index
    @user = current_user
    if @user.nil?
      redirect_to login_path, alert: "ログインしてください。"
      return
    end

    # 今日の学習時間を取得
    @todays_study_time = format_subject_times(StudyLog.study_time_today(@user))

    # 今週の学習時間を取得
    @this_weeks_study_time = format_subject_times(StudyLog.study_time_this_week(@user))

    # 今月の学習時間を取得
    @this_months_study_time = format_subject_times(StudyLog.study_time_this_month(@user))

    # 合計学習時間（全教科合計）
    @total_study_time = StudyLog.total_study_time(@user)

    # レポート
    @report = Report.find_or_initialize_by(user: @user)
  end
  
  def current_user
    User.find_by(id: session[:login_uid])  # session[:login_uid]がログインユーザーのIDである前提
  end

  private

  # 科目ごとの学習時間を整形
  def format_subject_times(subject_times)
    return {} if subject_times.blank?
    subject_times  # ここでハッシュ（科目: 時間）のまま返す
  end
end
