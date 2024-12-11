class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :report

  # 今日の目標を取得するスコープ
  scope :today, -> { where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) }

  # 今週の目標を取得するスコープ
  scope :this_week, -> { where(created_at: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week) }

  # 今月の目標を取得するスコープ
  scope :this_month, -> { where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month) }

  # 目標の進捗度を計算する
  def progress_percentage
    # start_date と end_date を period に基づいて設定
    case period
    when 'daily'
      start_date = Time.zone.now.beginning_of_day
      end_date = Time.zone.now.end_of_day
    when 'weekly'
      start_date = Time.zone.now.beginning_of_week
      end_date = Time.zone.now.end_of_week
    when 'monthly'
      start_date = Time.zone.now.beginning_of_month
      end_date = Time.zone.now.end_of_month
    else
      # period が 'daily', 'weekly', 'monthly' 以外の場合のデフォルト処理
      start_date = Time.zone.now
      end_date = Time.zone.now
    end

    # study_time の合計を取得
    total_study_time = StudyLog.where(user: user, created_at: start_date..end_date).sum(:study_time)

    # study_time が 0 の場合、進捗度を 0% とする
    return 0 if study_time.zero?

    # 進捗度を計算
    (total_study_time.to_f / study_time.to_f) * 100
  end
end
