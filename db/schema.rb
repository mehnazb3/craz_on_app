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

ActiveRecord::Schema.define(version: 20181021112904) do

  create_table "abuses", force: :cascade do |t|
    t.string "reason", default: "", null: false
    t.boolean "has_been_handled", default: false, null: false
    t.boolean "is_confirmed"
    t.integer "abusable_item_id"
    t.string "abusable_item_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "location_id"
    t.integer "user_id"
    t.index ["location_id"], name: "index_abuses_on_location_id"
    t.index ["user_id"], name: "index_abuses_on_user_id"
  end

  create_table "blocks", force: :cascade do |t|
    t.integer "blocker_id"
    t.integer "blocked_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blocked_id"], name: "index_blocks_on_blocked_id"
    t.index ["blocker_id", "blocked_id"], name: "index_blocks_on_blocker_id_and_blocked_id", unique: true
    t.index ["blocker_id"], name: "index_blocks_on_blocker_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "message", default: "", null: false
    t.integer "status", default: 0, null: false
    t.integer "commentable_item_id"
    t.string "commentable_item_type"
    t.boolean "is_a_reply", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "location_id"
    t.integer "user_id"
    t.index ["location_id"], name: "index_comments_on_location_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "follows", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_follows_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_follows_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.integer "likable_item_id"
    t.string "likable_item_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "location_id"
    t.integer "user_id"
    t.index ["likable_item_id", "likable_item_type", "user_id"], name: "unique_like", unique: true
    t.index ["location_id"], name: "index_likes_on_location_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "micro_blogs", force: :cascade do |t|
    t.string "message", default: "", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "location_id"
    t.integer "user_id"
    t.index ["location_id"], name: "index_micro_blogs_on_location_id"
    t.index ["user_id"], name: "index_micro_blogs_on_user_id"
  end

  create_table "shares", force: :cascade do |t|
    t.string "message"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "location_id"
    t.integer "micro_blog_id"
    t.integer "user_id"
    t.index ["location_id"], name: "index_shares_on_location_id"
    t.index ["micro_blog_id"], name: "index_shares_on_micro_blog_id"
    t.index ["user_id"], name: "index_shares_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "gender"
    t.integer "points", default: 0, null: false
    t.string "title", default: "", null: false
    t.boolean "is_admin", default: false, null: false
    t.string "auth_token"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "location_id"
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["location_id"], name: "index_users_on_location_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
