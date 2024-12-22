class User < ApplicationRecord
  # 学習ログとの関連（1対多）
  has_many :study_logs, dependent: :destroy

  # フレンドシップ（友達登録）との関連（1対多）
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships, source: :friend

  # いいねとの関連（1対多）
  has_many :likes, dependent: :destroy
  has_many :liked_study_logs, through: :likes, source: :study_log

  # コメントとの関連（1対多）
  has_many :comments, dependent: :destroy

  # レポートとの関連（1対多）
  has_many :reports, dependent: :destroy

  # 目標との関連（1対多）
  has_many :goals, dependent: :destroy

  # パスワードを使用するための設定
  has_secure_password validations: false # バリデーションを無効化

  # カスタムバリデーション
  validate :custom_validations

  private

  def custom_validations
    if name.blank?
      errors.add(:base, "名前 を入力してください")
    end
    if email.blank?
      errors.add(:base, "メールアドレス を入力してください")
    end
    if uid.blank?
      errors.add(:base, "ID を入力してください")
    end
    if password.blank?
      errors.add(:base, "パスワード を入力してください")
    end
  end
end