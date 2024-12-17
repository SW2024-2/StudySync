class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :study_log
  validates :content, presence: true
end
