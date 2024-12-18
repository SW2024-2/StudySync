class Like < ApplicationRecord
  belongs_to :user
  belongs_to :study_log
  # 1ユーザー1投稿につき1つの「いいね」
  validates :user_id, uniqueness: { scope: :study_log_id } 
end
