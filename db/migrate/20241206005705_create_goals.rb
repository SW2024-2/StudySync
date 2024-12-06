class CreateGoals < ActiveRecord::Migration[7.1]
  def change
    create_table :goals do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :target_time
      t.string :progress
      t.string :title

      t.timestamps
    end
  end
end
