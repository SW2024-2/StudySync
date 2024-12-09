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
  
   def study_time_for_period(period)
    case period
    when 'daily'
      # 今日の学習時間を計算
      study_time_today
    when 'weekly'
      # 今週の学習時間を計算
      study_time_this_week
    when 'monthly'
      # 今月の学習時間を計算
      study_time_this_month
    else
      0
    end
  end
end