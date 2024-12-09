class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :report
  
    # 今日の目標を取得するスコープ
  scope :today, -> { where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) }

  # 今週の目標を取得するスコープ
  scope :this_week, -> { where(created_at: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week) }

  # 今月の目標を取得するスコープ
  scope :this_month, -> { where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month) }

  
  # 進捗度を計算するメソッド
  def progress_percentage
    # 今日、今週、今月の学習時間を基に進捗度を計算
    completed_study_time = report.study_time_for_period(period)
    return 0 if completed_study_time == 0
    (completed_study_time.to_f / study_time) * 100
  end
end
