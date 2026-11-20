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

ActiveRecord::Schema[8.1].define(version: 2026_11_20_013955) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.date "assigned_at", null: false
    t.datetime "created_at", null: false
    t.bigint "mechanic_id", null: false
    t.bigint "order_id", null: false
    t.datetime "updated_at", null: false
    t.index ["mechanic_id"], name: "index_assignments_on_mechanic_id"
    t.index ["order_id", "mechanic_id"], name: "index_assignments_on_order_id_and_mechanic_id", unique: true
    t.index ["order_id"], name: "index_assignments_on_order_id"
  end

  create_table "cars", force: :cascade do |t|
    t.string "brand"
    t.string "chassis"
    t.string "color"
    t.datetime "created_at", null: false
    t.bigint "customer_id", null: false
    t.integer "mileage", default: 0
    t.string "model"
    t.string "plate"
    t.datetime "updated_at", null: false
    t.integer "year"
    t.index ["chassis"], name: "index_cars_on_chassis", unique: true
    t.index ["customer_id"], name: "index_cars_on_customer_id"
    t.index ["plate"], name: "index_cars_on_plate", unique: true
  end

  create_table "customers", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "address"
    t.datetime "created_at", null: false
    t.string "document_number"
    t.string "document_type", default: "CI"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.index ["document_number"], name: "index_customers_on_document_number", unique: true
  end

  create_table "mechanics", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "specialty"
    t.datetime "updated_at", null: false
  end

  create_table "order_details", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "order_id", null: false
    t.integer "quantity", default: 1, null: false
    t.bigint "service_id", null: false
    t.integer "subtotal", default: 0, null: false
    t.integer "unit_price", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_details_on_order_id"
    t.index ["service_id"], name: "index_order_details_on_service_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "car_id", null: false
    t.datetime "created_at", null: false
    t.date "delivery_date"
    t.string "notes"
    t.date "order_date", null: false
    t.string "status", default: "Pendiente", null: false
    t.integer "total", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_orders_on_car_id"
  end

  create_table "services", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name"
    t.integer "price"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "assignments", "mechanics"
  add_foreign_key "assignments", "orders"
  add_foreign_key "cars", "customers"
  add_foreign_key "order_details", "orders"
  add_foreign_key "order_details", "services"
  add_foreign_key "orders", "cars"
end
