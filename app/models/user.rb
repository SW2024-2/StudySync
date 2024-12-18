class User < ApplicationRecord
  # 学習ログとの関連（1対多）
  has_many :study_logs, dependent: :destroy

  # フレンドシップ（友達登録）との関連（1対多）
  has_many :friendships, dependent: :destroy

  # friendsを通じて友達関係を構築（Userモデルに関連するfriendを取得）
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
  
  # 必要に応じて、バリデーションや認証機能のための設定を追加可能
  # 友達として追加された場合（逆方向の関連）
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy
  has_many :inverse_friends, through: :inverse_friendships, source: :user
end