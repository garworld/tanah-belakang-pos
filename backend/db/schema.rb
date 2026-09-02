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

ActiveRecord::Schema[8.1].define(version: 2026_08_20_084728) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_active", default: true, null: false
    t.string "name", limit: 100, null: false
    t.integer "sort_order", default: 0, null: false
    t.datetime "updated_at", null: false
    t.check_constraint "sort_order >= 0", name: "categories_sort_order_check"
  end

  create_table "shifts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "actual_closing_cash"
    t.datetime "closed_at"
    t.datetime "created_at", null: false
    t.datetime "opened_at", null: false
    t.integer "opening_cash", null: false
    t.string "status", limit: 20, null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["user_id"], name: "index_shifts_on_user_id"
    t.index ["user_id"], name: "index_shifts_one_open_per_user", unique: true, where: "((status)::text = 'OPEN'::text)"
    t.check_constraint "actual_closing_cash IS NULL OR actual_closing_cash >= 0", name: "shifts_closing_cash_check"
    t.check_constraint "opening_cash >= 0", name: "shifts_opening_cash_check"
    t.check_constraint "status::text = 'OPEN'::text AND closed_at IS NULL AND actual_closing_cash IS NULL OR status::text = 'CLOSED'::text AND closed_at IS NOT NULL AND actual_closing_cash IS NOT NULL", name: "shifts_state_check"
    t.check_constraint "status::text = ANY (ARRAY['OPEN'::character varying, 'CLOSED'::character varying]::text[])", name: "shifts_status_check"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_active", default: true, null: false
    t.string "name", limit: 100, null: false
    t.text "pin_hash", null: false
    t.string "role", limit: 20, null: false
    t.datetime "updated_at", null: false
    t.check_constraint "role::text = ANY (ARRAY['CASHIER'::character varying, 'ADMIN'::character varying]::text[])", name: "users_role_check"
  end

  add_foreign_key "shifts", "users"
end
