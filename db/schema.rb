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

ActiveRecord::Schema.define(version: 2019_02_01_111500) do

  create_table "contributors", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contributors_package_versions", force: :cascade do |t|
    t.integer "contributor_id"
    t.integer "package_version_id"
    t.string "role", default: "maintainer", null: false
    t.index ["contributor_id"], name: "index_contributors_package_versions_on_contributor_id"
    t.index ["package_version_id"], name: "index_contributors_package_versions_on_package_version_id"
  end

  create_table "package_versions", force: :cascade do |t|
    t.integer "package_id", null: false
    t.string "version"
    t.date "publication_date"
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["package_id"], name: "index_package_versions_on_package_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "name"
    t.string "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "latest_version_id"
    t.index ["latest_version_id"], name: "index_packages_on_latest_version_id"
  end

end
