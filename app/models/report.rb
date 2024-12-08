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
end
