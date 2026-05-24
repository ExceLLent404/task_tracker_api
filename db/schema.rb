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

ActiveRecord::Schema[8.1].define(version: 2026_05_24_130820) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.boolean "system", default: false, null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "task_instances", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "scheduled_date", null: false
    t.integer "status", default: 0, null: false
    t.bigint "task_template_id", null: false
    t.datetime "updated_at", null: false
    t.index ["scheduled_date"], name: "index_task_instances_on_scheduled_date"
    t.index ["task_template_id", "scheduled_date"], name: "index_task_instances_on_task_template_id_and_scheduled_date", unique: true
    t.index ["task_template_id"], name: "index_task_instances_on_task_template_id"
  end

  create_table "task_template_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "tag_id", null: false
    t.bigint "task_template_id", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_task_template_tags_on_tag_id"
    t.index ["task_template_id", "tag_id"], name: "index_task_template_tags_on_task_template_id_and_tag_id", unique: true
    t.index ["task_template_id"], name: "index_task_template_tags_on_task_template_id"
  end

  create_table "task_templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "task_instances", "task_templates"
  add_foreign_key "task_template_tags", "tags"
  add_foreign_key "task_template_tags", "task_templates"
end
