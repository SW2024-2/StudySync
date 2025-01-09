class Subject < ApplicationRecord
    has_many :study_logs  # StudyLogとの関連を追加
    has_and_belongs_to_many :goals
    belongs_to :user
end