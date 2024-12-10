class CreateGoals < ActiveRecord::Migration[7.1]
  def change
    create_table :goals do |t|
      t.string :title, null: false          # 目標のタイトル
      t.integer :study_time, null: false    # 目標の学習時間 (分)
      t.references :report, null: false, foreign_key: true  # report_id（Reportとの関連）
      t.references :user, null: false, foreign_key: true   # user_id（Userとの関連）
      t.string :period, null: false, default: 'today' # 目標の期間 ('today', 'this_week', 'this_month')
      t.integer :progress_percentage
      
      t.timestamps
    end
  end
end
