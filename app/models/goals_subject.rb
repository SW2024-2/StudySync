class GoalsSubject < ApplicationRecord
  belongs_to :goal
  belongs_to :subject
end
