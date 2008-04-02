# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 12) do

  create_table "listings", :force => true do |t|
    t.integer  "track_id"
    t.integer  "playlist_id"
    t.integer  "index"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "listings", ["track_id"], :name => "index_listings_on_track_id"

  create_table "played_tracks", :force => true do |t|
    t.integer  "track_id"
    t.string   "queued_by"
    t.datetime "created_at"
    t.integer  "playlist_id"
    t.datetime "updated_at"
  end

  create_table "playlists", :force => true do |t|
    t.string   "name"
    t.integer  "index"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "queued_tracks", :force => true do |t|
    t.integer  "track_id"
    t.string   "queued_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "playlist_id"
    t.integer  "position"
  end

  create_table "tracks", :force => true do |t|
    t.string   "name"
    t.integer  "index"
    t.string   "artist"
    t.string   "album"
    t.integer  "play_count",  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "database_id"
  end

end
