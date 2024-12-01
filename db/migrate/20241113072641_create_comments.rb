class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :study_log, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
