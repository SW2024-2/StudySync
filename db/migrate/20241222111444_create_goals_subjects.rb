class CreateGoalsSubjects < ActiveRecord::Migration[7.1]
  def change
    create_table :goals_subjects do |t|
      t.references :goal, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true

      t.timestamps
    end
  end
end
