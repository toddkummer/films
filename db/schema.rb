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

ActiveRecord::Schema[8.0].define(version: 2024_10_01_221924) do
  create_table "acting_credits", force: :cascade do |t|
    t.integer "film_id", null: false
    t.integer "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["film_id"], name: "index_acting_credits_on_film_id"
    t.index ["person_id"], name: "index_acting_credits_on_person_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "directing_credits", force: :cascade do |t|
    t.integer "film_id", null: false
    t.integer "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["film_id"], name: "index_directing_credits_on_film_id"
    t.index ["person_id"], name: "index_directing_credits_on_person_id"
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
    t.integer "distributor_id"
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

  create_table "posters", force: :cascade do |t|
    t.integer "film_id", null: false
    t.string "filename", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["film_id"], name: "index_posters_on_film_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "writing_credits", force: :cascade do |t|
    t.integer "film_id", null: false
    t.integer "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["film_id"], name: "index_writing_credits_on_film_id"
    t.index ["person_id"], name: "index_writing_credits_on_person_id"
  end

  add_foreign_key "acting_credits", "films"
  add_foreign_key "acting_credits", "people"
  add_foreign_key "directing_credits", "films"
  add_foreign_key "directing_credits", "people"
  add_foreign_key "film_locations", "films"
  add_foreign_key "film_locations", "locations"
  add_foreign_key "films", "companies", column: "distributor_id"
  add_foreign_key "films", "companies", column: "production_company_id"
  add_foreign_key "person_roles", "people"
  add_foreign_key "posters", "films"
  add_foreign_key "sessions", "users"
  add_foreign_key "writing_credits", "films"
  add_foreign_key "writing_credits", "people"
end
