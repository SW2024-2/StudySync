class Report < ApplicationRecord
  belongs_to :user
  has_many :goals, dependent: :destroy # これを追加

  # レポートを作成するメソッド（今日、今週、今月、合計など）
  def self.create_report(user, date_range, total_study_time)
    create(
      user: user,
      date_range: date_range,
      total_study_time: total_study_time
    )
  end
  
  # periodに応じた学習時間を計算するメソッド
  def study_time_for_period(period)
    case period
    when 'daily'
      study_time_today
    when 'weekly'
      study_time_this_week
    when 'monthly'
      study_time_this_month
    else
      0
    end
  end

  # 今日の学習時間を計算するメソッド
  def study_time_today
    # 今日の日付の学習時間を合計
    self.goals.where(created_at: Date.today.all_day).sum(:study_time)
  end

  # 今週の学習時間を計算するメソッド
  def study_time_this_week
    # 今週の月曜日から日曜日までの学習時間を合計
    self.goals.where(created_at: (Date.today.beginning_of_week..Date.today.end_of_week)).sum(:study_time)
  end

  # 今月の学習時間を計算するメソッド
  def study_time_this_month
    # 今月の1日から今日までの学習時間を合計
    self.goals.where(created_at: Date.today.beginning_of_month..Date.today.end_of_month).sum(:study_time)
  end
end
