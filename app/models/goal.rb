class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :report
  has_and_belongs_to_many :subjects  # 科目との多対多の関連付け

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

    # 進捗度を計算するための科目ごとの学習時間を取得
    subject_ids = subjects.pluck(:id)  # 関連する科目IDを取得
    total_study_time = StudyLog.where(user: user, subject_id: subject_ids, created_at: start_date..end_date).sum(:study_time)

    # 学習時間が0の場合、進捗度を 0% とする
    return 0 if study_time.zero?

    # 進捗度を計算
    progress = (total_study_time.to_f / study_time.to_f) * 100

    # 最大100%を超えないようにする
    [progress, 100].min
  end
  
  # バリデーション
  validate :study_time_must_be_at_least_one_minute
  validate :custom_validations
  validates :subjects, presence: true, length: { minimum: 1 }

  # カスタムバリデーション
  def custom_validations
    if title.blank?
      errors.add(:base, "タイトルを入力してください")
    end
  end

  # 学習時間が1分未満の場合のバリデーション
  def study_time_must_be_at_least_one_minute
    if total_study_time < 1
      errors.add(:base, "学習時間は1分以上にしてください")
    end
  end
end
