class StudyLog < ApplicationRecord
  belongs_to :user

  # 今日の学習時間を教科ごとに取得
  def self.study_time_today(user)
    where(user: user, created_at: Date.today.beginning_of_day..Date.today.end_of_day)
      .group(:subject)  # 教科ごとにグループ化
      .sum(:study_time) # 各教科の学習時間を合計
  end

  # 今週の学習時間を教科ごとに取得
  def self.study_time_this_week(user)
    where(user: user, created_at: Date.today.beginning_of_week..Date.today.end_of_week)
      .group(:subject)
      .sum(:study_time)
  end

  # 今月の学習時間を教科ごとに取得
  def self.study_time_this_month(user)
    where(user: user, created_at: Date.today.beginning_of_month..Date.today.end_of_month)
      .group(:subject)
      .sum(:study_time)
  end

  # 合計学習時間（教科関係なし）
  def self.total_study_time(user)
    where(user: user).sum(:study_time)  # 全体の学習時間の合計
  end
  
  def self.total_study_time_for_goal(user, goal)
    return 0 if goal.nil?

    # 目標の開始日から現在までの学習時間を集計
    total_study_time = where(user: user, created_at: goal.created_at..Time.current).sum(:study_time)
    
    # 目標設定前の学習データも進捗度に加算
    total_study_time_before_goal = where(user: user, created_at: ..goal.created_at).sum(:study_time)

    total_study_time + total_study_time_before_goal
  end
end