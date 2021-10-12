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

ActiveRecord::Schema.define(version: 2021_10_12_194446) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.bigint "post_info_id", null: false
    t.string "reply"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_info_id"], name: "index_comments_on_post_info_id"
  end

  create_table "followers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "follower_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["follower_id"], name: "index_followers_on_follower_id"
    t.index ["user_id"], name: "index_followers_on_user_id"
  end

  create_table "followings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "following_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["following_id"], name: "index_followings_on_following_id"
    t.index ["user_id"], name: "index_followings_on_user_id"
  end

  create_table "post_infos", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "user_id", null: false
    t.boolean "liked", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_post_infos_on_post_id"
    t.index ["user_id"], name: "index_post_infos_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "message"
    t.integer "number_of_likes", default: 0
    t.integer "number_of_replys", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password"
    t.string "password_digest"
    t.string "date_of_birth"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "comments", "post_infos"
  add_foreign_key "followers", "users"
  add_foreign_key "followers", "users", column: "follower_id"
  add_foreign_key "followings", "users"
  add_foreign_key "followings", "users", column: "following_id"
  add_foreign_key "post_infos", "posts"
  add_foreign_key "post_infos", "users"
  add_foreign_key "posts", "users"
end
