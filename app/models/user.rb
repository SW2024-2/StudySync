class User < ApplicationRecord
  # 学習ログとの関連（1対多）
  has_many :study_logs

  # フレンドシップ（友達登録）との関連（1対多）
  has_many :friendships

  # friendsを通じて友達関係を構築（Userモデルに関連するfriendを取得）
  has_many :friends, through: :friendships, source: :friend

  # いいねとの関連（1対多）
  has_many :likes

  # コメントとの関連（1対多）
  has_many :comments

  # レポートとの関連（1対多）
  has_many :reports
  
  # 必要に応じて、バリデーションや認証機能のための設定を追加可能
end
