# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161021110505) do

  create_table "activities", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "tagget_id"
    t.string   "tagget_type"
    t.string   "action_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "answers", force: :cascade do |t|
    t.integer  "word_id"
    t.text     "content"
    t.boolean  "correct",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["word_id"], name: "index_answers_on_word_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "choices", force: :cascade do |t|
    t.integer  "result_id"
    t.integer  "anser_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["anser_id"], name: "index_choices_on_anser_id"
    t.index ["result_id"], name: "index_choices_on_result_id"
  end

  create_table "lessions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "category"
    t.string   "name"
    t.integer  "number_of_words"
    t.integer  "time"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["user_id"], name: "index_lessions_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "results", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "lession_id"
    t.integer  "word_id_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lession_id"], name: "index_results_on_lession_id"
    t.index ["user_id"], name: "index_results_on_user_id"
    t.index ["word_id_id"], name: "index_results_on_word_id_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.date     "birthday"
    t.string   "sex"
    t.string   "address"
    t.string   "phone"
    t.string   "avatar"
    t.string   "password_digest"
    t.string   "protected_digest"
    t.boolean  "admin",            default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "words", force: :cascade do |t|
    t.integer  "category_id"
    t.text     "content"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["category_id"], name: "index_words_on_category_id"
  end

end
