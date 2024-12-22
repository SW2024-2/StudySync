# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_12_22_111444) do
  create_table "comments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "study_log_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["study_log_id"], name: "index_comments_on_study_log_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "friend_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "goals", force: :cascade do |t|
    t.string "title", null: false
    t.integer "study_time", null: false
    t.integer "report_id", null: false
    t.integer "user_id", null: false
    t.string "period", default: "today", null: false
    t.integer "progress_percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_goals_on_report_id"
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "goals_subjects", force: :cascade do |t|
    t.integer "goal_id", null: false
    t.integer "subject_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["goal_id"], name: "index_goals_subjects_on_goal_id"
    t.index ["subject_id"], name: "index_goals_subjects_on_subject_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "study_log_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["study_log_id"], name: "index_likes_on_study_log_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "date_range"
    t.integer "total_study_time"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "study_logs", force: :cascade do |t|
    t.integer "user_id", null: false
    t.text "note"
    t.integer "study_time_hours"
    t.integer "study_time_minutes"
    t.integer "study_time"
    t.string "study_time_method"
    t.integer "stopwatch_time", default: 0
    t.integer "timer_time"
    t.integer "timer_remaining"
    t.integer "subject_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_study_logs_on_user_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "comments", "study_logs"
  add_foreign_key "comments", "users"
  add_foreign_key "friendships", "users"
  add_foreign_key "friendships", "users", column: "friend_id"
  add_foreign_key "goals", "reports"
  add_foreign_key "goals", "users"
  add_foreign_key "goals_subjects", "goals"
  add_foreign_key "goals_subjects", "subjects"
  add_foreign_key "likes", "study_logs"
  add_foreign_key "likes", "users"
  add_foreign_key "reports", "users"
  add_foreign_key "study_logs", "users"
end
