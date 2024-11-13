class CreateStudyLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :study_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :subject
      t.string :study_time
      t.string :integer
      t.text :note

      t.timestamps
    end
  end
end
