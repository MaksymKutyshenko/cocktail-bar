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

ActiveRecord::Schema.define(version: 20151209172102) do

  create_table "cocktails", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "image"
    t.text     "description"
  end

  create_table "ingridients", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "cocktail_id"
    t.float    "value"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "ordered_cocktails", force: :cascade do |t|
    t.integer  "cocktail_id"
    t.integer  "order_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "table_id"
    t.integer  "status"
    t.float    "sum"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.float    "cost_price"
    t.float    "min_value"
    t.string   "product_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "image"
  end

  add_index "products", ["name"], name: "index_products_on_name"

  create_table "tables", force: :cascade do |t|
    t.string   "name"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "avatar"
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "waiters", force: :cascade do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "photo"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "worksets", force: :cascade do |t|
    t.integer  "table_id"
    t.integer  "waiter_id"
    t.integer  "status"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.float    "total_earned"
  end

end
