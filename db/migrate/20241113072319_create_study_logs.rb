class CreateStudyLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :study_logs do |t|
      t.references :user, null: false, foreign_key: true # ユーザーとの関連
      t.string :subject # 科目
      t.text :note # ノート
      t.integer :study_time_hours # 時間
      t.integer :study_time_minutes # 分
      t.integer :study_time # 学習時間（計算された結果として保存する場合）
      t.string :study_time_method # 学習方法（手動、ストップウォッチ、タイマー）
      t.integer :stopwatch_time # ストップウォッチの時間
      t.integer :timer_time # タイマーの時間
      t.integer :timer_remaining # タイマー残り時間

      t.timestamps
    end
  end
end