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

ActiveRecord::Schema.define(version: 20180614062942) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"
  enable_extension "dblink"
  enable_extension "pg_trgm"
  enable_extension "btree_gist"

  create_table "songs", force: :cascade do |t|
    t.citext "title"
    t.citext "artist"
    t.bigint "added_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "mb_recording"
    t.integer "mb_artist_credit"
    t.integer "mb_work"
    t.index ["added_by_id"], name: "index_songs_on_added_by_id"
    t.index ["artist"], name: "index_songs_on_artist"
    t.index ["title", "artist"], name: "index_songs_on_title_and_artist", using: :gist
    t.index ["title"], name: "index_songs_on_title"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "song_id"
    t.bigint "tag_id"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.index ["category"], name: "index_taggings_on_category"
    t.index ["created_by_id"], name: "index_taggings_on_created_by_id"
    t.index ["song_id", "tag_id", "category"], name: "index_taggings_on_song_id_and_tag_id_and_category", unique: true
    t.index ["song_id"], name: "index_taggings_on_song_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.citext "name"
    t.bigint "added_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["added_by_id"], name: "index_tags_on_added_by_id"
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider"], name: "index_users_on_provider"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid"], name: "index_users_on_uid"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.integer "vote", limit: 2
    t.bigint "user_id"
    t.string "voteable_type"
    t.bigint "voteable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_votes_on_user_id"
    t.index ["voteable_type", "voteable_id"], name: "index_votes_on_voteable_type_and_voteable_id"
  end

  add_foreign_key "taggings", "songs"
  add_foreign_key "taggings", "tags"
  add_foreign_key "taggings", "users", column: "created_by_id"
  add_foreign_key "votes", "users"
end
