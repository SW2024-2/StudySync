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
    start_of_week = Time.zone.now.beginning_of_week
    end_of_week = Time.zone.now.end_of_week

    where(user: user, created_at: start_of_week..end_of_week)
      .group(:subject)
      .sum(:study_time)
  end

  # 今月の学習時間を教科ごとに取得
  def self.study_time_this_month(user)
    start_of_month = Time.zone.now.beginning_of_month
    end_of_month = Time.zone.now.end_of_month

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

  # 学習時間が1分以上であることを検証
  validate :study_time_is_valid

  # 学習時間の記録方法が未選択の場合にエラーメッセージを追加
  validate :study_time_method_selected

  # タイトルのバリデーション（カスタム）
  validate :custom_validations

  def custom_validations
    if study_time.blank?
      errors.add(:base, '学習時間を入力してください')
    end
    if subject.blank?
      errors.add(:base, '教科を入力してください')
    end
  end

  # 学習時間の記録方法が選択されていない場合にエラーメッセージを追加
  def study_time_method_selected
    if study_time_method.blank?
      errors.add(:base, '学習時間の記録方法を選択してください')
    end
  end

  # 学習時間が1分以上であることを検証
  def study_time_is_valid
    if study_time.present? && study_time < 1
      errors.add(:base, '学習時間を1分以上である必要があります')
    end
  end
end
