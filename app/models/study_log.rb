class StudyLog < ApplicationRecord
  # ユーザーに属する（多対1）
  belongs_to :user

  # いいねとの関連（1対多）
  has_many :likes, dependent: :destroy

  # コメントとの関連（1対多）
  has_many :comments, dependent: :destroy

  # バリデーションや追加機能があれば追加
end