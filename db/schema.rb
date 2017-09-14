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

ActiveRecord::Schema.define(version: 20170914163459) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "songs", force: :cascade do |t|
    t.citext "title"
    t.citext "artist"
    t.bigint "added_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["added_by_id"], name: "index_songs_on_added_by_id"
    t.index ["artist"], name: "index_songs_on_artist"
    t.index ["title", "artist"], name: "index_songs_on_title_and_artist", unique: true
    t.index ["title"], name: "index_songs_on_title"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "song_id"
    t.bigint "tag_id"
    t.bigint "created_by_id"
    t.integer "approvals", default: 0
    t.integer "disapprovals", default: 0
    t.decimal "score", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_taggings_on_created_by_id"
    t.index ["song_id", "tag_id"], name: "index_taggings_on_song_id_and_tag_id", unique: true
    t.index ["song_id"], name: "index_taggings_on_song_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "taggings_types", force: :cascade do |t|
    t.bigint "tagging_id"
    t.bigint "type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tagging_id"], name: "index_taggings_types_on_tagging_id"
    t.index ["type_id"], name: "index_taggings_types_on_type_id"
  end

  create_table "tags", force: :cascade do |t|
    t.citext "name"
    t.bigint "added_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["added_by_id"], name: "index_tags_on_added_by_id"
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "taggings", "songs"
  add_foreign_key "taggings", "tags"
  add_foreign_key "taggings", "users", column: "created_by_id"
  add_foreign_key "taggings_types", "taggings"
  add_foreign_key "taggings_types", "types"
end
