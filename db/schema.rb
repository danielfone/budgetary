# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160216031005) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bank_transactions", force: :cascade do |t|
    t.string   "account_id",      null: false
    t.string   "fit_id",          null: false
    t.decimal  "amount",          null: false
    t.datetime "posted_at",       null: false
    t.json     "data"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "txn_category_id"
    t.index ["account_id", "fit_id"], name: "index_bank_transactions_on_account_id_and_fit_id", unique: true, using: :btree
    t.index ["txn_category_id"], name: "index_bank_transactions_on_txn_category_id", using: :btree
  end

  create_table "txn_categories", force: :cascade do |t|
    t.string   "name",                          null: false
    t.string   "category_type",                 null: false
    t.decimal  "budget"
    t.string   "budget_period"
    t.boolean  "archived",      default: false, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["archived"], name: "index_txn_categories_on_archived", using: :btree
    t.index ["category_type"], name: "index_txn_categories_on_category_type", using: :btree
  end

  add_foreign_key "bank_transactions", "txn_categories"
end
