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

ActiveRecord::Schema.define(version: 2018_11_08_040052) do

  create_table "links", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "code"
    t.string "original", limit: 512
    t.string "url_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_links_on_code"
    t.index ["url_digest"], name: "index_links_on_url_digest"
  end

  create_table "viewers", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "ip"
    t.string "browser"
    t.string "browser_version"
    t.string "os"
    t.string "country"
    t.string "city"
    t.string "ua", limit: 512
    t.string "viewer_digest"
    t.integer "view_count", default: 0
    t.bigint "link_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["link_id"], name: "index_viewers_on_link_id"
    t.index ["viewer_digest"], name: "index_viewers_on_viewer_digest"
  end

end
