class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :study_log
end
