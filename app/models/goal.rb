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
    total_study_time = StudyLog.total_study_time_for_goal(user, self)
    return 0 if study_time == 0
    (total_study_time.to_f / study_time.to_f) * 100
  end
end
