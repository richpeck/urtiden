# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_07_16_075914) do

  create_table "jobs", force: :cascade do |t|
    t.integer "shop_id"
    t.integer "product_id"
    t.string "active_job_id"
    t.datetime "finished_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_jobs_on_product_id"
    t.index ["shop_id"], name: "index_jobs_on_shop_id"
  end

  create_table "products", force: :cascade do |t|
    t.integer "shop_id"
    t.integer "id_product"
    t.integer "id_brand"
    t.integer "id_supplier"
    t.string "id_shopify"
    t.integer "ean", limit: 8
    t.text "name"
    t.text "slug"
    t.string "reference"
    t.string "category"
    t.string "group"
    t.string "brand_name"
    t.decimal "price", precision: 10, scale: 2
    t.integer "retail_price"
    t.decimal "discount", precision: 10, scale: 2
    t.integer "weight"
    t.integer "stock"
    t.integer "min_qty"
    t.integer "speed_shipping"
    t.text "attribs", limit: 1500
    t.text "response"
    t.text "icon"
    t.text "image"
    t.datetime "img_last_update"
    t.datetime "synced_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id_product"], name: "index_products_on_id_product", unique: true
    t.index ["shop_id"], name: "index_products_on_shop_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "shopify_domain", null: false
    t.string "shopify_token", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true
  end

end
