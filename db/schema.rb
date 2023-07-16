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

ActiveRecord::Schema[7.0].define(version: 2023_07_16_222405) do
  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "film_locations", force: :cascade do |t|
    t.integer "film_id", null: false
    t.integer "location_id", null: false
    t.string "fun_facts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["film_id"], name: "index_film_locations_on_film_id"
    t.index ["location_id"], name: "index_film_locations_on_location_id"
  end

  create_table "films", force: :cascade do |t|
    t.string "name", null: false
    t.integer "release_year", null: false
    t.integer "production_company_id", null: false
    t.integer "distributor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["distributor_id"], name: "index_films_on_distributor_id"
    t.index ["production_company_id"], name: "index_films_on_production_company_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name", null: false
    t.integer "find_neighborhood_id"
    t.string "analysis_neighborhood_id"
    t.integer "supervisor_district_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "person_roles", force: :cascade do |t|
    t.integer "role"
    t.integer "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_person_roles_on_person_id"
  end

  add_foreign_key "film_locations", "films"
  add_foreign_key "film_locations", "locations"
  add_foreign_key "films", "companies", column: "distributor_id"
  add_foreign_key "films", "companies", column: "production_company_id"
  add_foreign_key "person_roles", "people"
end
