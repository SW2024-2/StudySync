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
    # 目標に対する学習時間を取得
    total_study_time_for_goal = StudyLog.total_study_time_for_goal(user, self) || 0

    # 学習時間がゼロの場合は進捗度を0%に
    return 0 if total_study_time_for_goal == 0

    # 進捗度を計算（進捗度は最大100%に制限）
    progress = (total_study_time_for_goal.to_f / study_time) * 100
    [progress, 100].min.round(2)
  end
end
