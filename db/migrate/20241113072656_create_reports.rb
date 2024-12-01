class CreateReports < ActiveRecord::Migration[7.1]
  def change
    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.string :date_range
      t.integer :total_study_time

      t.timestamps
    end
  end
end
