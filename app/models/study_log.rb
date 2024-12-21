class StudyLog < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  # 学習日をフォーマットして返す
  def formatted_study_date(format = '%Y/%m/%d')
    created_at.strftime(format)
  end

  # 今日の学習時間を教科ごとに取得
  def self.study_time_today(user)
    start_of_today = Time.zone.now.beginning_of_day
    end_of_today = Time.zone.now.end_of_day

    where(user: user, created_at: start_of_today..end_of_today)
      .group(:subject)  # 教科ごとにグループ化
      .sum(:study_time) # 各教科の学習時間を合計
  end

  # 今週の学習時間を教科ごとに取得
  def self.study_time_this_week(user)
    start_of_week = Date.today.beginning_of_week
    end_of_week = Date.today.end_of_week

    where(user: user, created_at: start_of_week..end_of_week)
      .group(:subject)
      .sum(:study_time)
  end

  # 今月の学習時間を教科ごとに取得
  def self.study_time_this_month(user)
    start_of_month = Date.today.beginning_of_month
    end_of_month = Date.today.end_of_month

    where(user: user, created_at: start_of_month..end_of_month)
      .group(:subject)
      .sum(:study_time)
  end

  # 合計学習時間（教科関係なし）
  def self.total_study_time(user)
    where(user: user).sum(:study_time)
  end

  # 目標に対する進捗度を計算
  def self.total_study_time_for_goal(user, goal)
    return 0 if goal.nil?

    where(user: user, created_at: goal.created_at..Time.current).sum(:study_time)
  end

  # 学習時間を分:秒の形式で表示
  def study_time_display
    time_in_seconds = study_time || 0 # study_timeがnilの場合は0をデフォルトに
    minutes = (time_in_seconds / 60).floor
    seconds = time_in_seconds % 60
    format("%02d:%02d", minutes, seconds)
  end
  
  # ユーザーがこの投稿を「いいね」しているかを判定
  def liked_by?(user)
    likes.exists?(user: user)
  end

  # バリデーションの追加
  validates :subject, presence: true # 科目は必須
  validates :study_time_method, presence: true # 学習方法は必須

  validate :study_time_required_for_manual_input, if: :manual_input?
  validate :study_time_required_for_stopwatch, if: :stopwatch_input?
  validate :study_time_required_for_timer, if: :timer_input?

  # 手動入力かどうかを判定するメソッド
  def manual_input?
    study_time_method == '手動'
  end

  def stopwatch_input?
    study_time_method == 'ストップウォッチ'
  end

  def timer_input?
    study_time_method == 'タイマー'
  end

  # 手動入力時に学習時間が入力されていない場合にエラーを追加
  def study_time_required_for_manual_input
    if study_time_hours.blank? && study_time_minutes.blank?
      errors.add(:study_time, "は手動入力時に時間または分を入力してください。")
    elsif study_time_hours.to_i <= 0 && study_time_minutes.to_i <= 0
      errors.add(:study_time, "は1分以上で入力してください。")
    end
  end

  # ストップウォッチ入力時に時間が0秒でないことを確認
  def study_time_required_for_stopwatch
    if stopwatch_time.to_i <= 0
      errors.add(:stopwatch_time, "は0秒以上である必要があります。")
    end
  end

  # タイマー入力時にタイマー時間または残り時間が正しいことを確認
  def study_time_required_for_timer
    if timer_time.to_i <= 0 && timer_remaining.to_i <= 0
      errors.add(:timer_time, "は正しいタイマー時間または残り時間を入力してください。")
    end
  end
end
