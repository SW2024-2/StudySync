class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :report
  
  # 仮の属性を定義
  attr_accessor :study_time_hours, :study_time_minutes

  # 学習時間を合計して保存
  def total_study_time
    (study_time_hours.to_i * 60) + study_time_minutes.to_i
  end

  # `study_time` を更新するメソッドを追加
  def update_study_time
    self.study_time = total_study_time
  end

  # 学習時間を更新するためのコールバック
  before_save :update_study_time

  # 今日の目標を取得するスコープ
  scope :today, -> { where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) }

  # 今週の目標を取得するスコープ
  scope :this_week, -> { where(created_at: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week) }

  # 今月の目標を取得するスコープ
  scope :this_month, -> { where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month) }

  # 目標の進捗度を計算する
  def progress_percentage
    # start_date と end_date を period に基づいて設定
    start_date, end_date = case period
                           when 'daily'
                             [Time.zone.now.beginning_of_day, Time.zone.now.end_of_day]
                           when 'weekly'
                             [Time.zone.now.beginning_of_week, Time.zone.now.end_of_week]
                           when 'monthly'
                             [Time.zone.now.beginning_of_month, Time.zone.now.end_of_month]
                           else
                             [Time.zone.now, Time.zone.now] # デフォルト処理
                           end

    # 進捗度を計算するための総学習時間を取得
    total_study_time = StudyLog.where(user: user, created_at: start_date..end_date).sum(:study_time)

    # 学習時間が0の場合、進捗度を 0% とする
    return 0 if study_time.zero?

    # 進捗度を計算
    progress = (total_study_time.to_f / study_time.to_f) * 100

    # 最大100%を超えないようにする
    [progress, 100].min
  end
  
   validates :title, presence: true, length: { maximum: 255 }
   validates :study_time, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
