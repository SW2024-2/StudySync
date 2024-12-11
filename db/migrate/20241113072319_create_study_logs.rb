class CreateStudyLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :study_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :subject
      t.integer :study_time # 学習時間（手動入力など）
      t.text :note
      t.string :study_time_method # 学習時間記録方法（手動、ストップウォッチ、タイマー）
      t.integer :stopwatch_time, default: 0 # ストップウォッチで計測した時間（秒）
      t.integer :timer_time, default: 0 # タイマーで設定した時間（秒）
      t.integer :custom_timer, default: 0 # タイマーのカスタム時間（秒）

      t.timestamps
    end
  end
end
