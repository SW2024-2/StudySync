class CreateReports < ActiveRecord::Migration[7.1]
  def change
    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.string :date_range   # 今日、今週、今月、合計など
      t.integer :total_study_time  # 学習時間の合計

      t.timestamps
    end
  end
end
