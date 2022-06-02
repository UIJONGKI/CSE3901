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

ActiveRecord::Schema.define(version: 2022_04_27_232429) do

  create_table "course_interests", force: :cascade do |t|
    t.integer "grader_id"
    t.integer "course_id"
    t.integer "course_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_course_interests_on_course_id"
    t.index ["grader_id"], name: "index_course_interests_on_grader_id"
  end

  create_table "course_qualifications", force: :cascade do |t|
    t.integer "grader_id"
    t.integer "course_id"
    t.integer "course_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_course_qualifications_on_course_id"
    t.index ["grader_id"], name: "index_course_qualifications_on_grader_id"
  end

  create_table "courses", force: :cascade do |t|
    t.integer "courseNumber"
    t.string "courseName"
    t.boolean "inClassGraders", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "grader_assignments", force: :cascade do |t|
    t.integer "grader_id"
    t.integer "section_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["grader_id"], name: "index_grader_assignments_on_grader_id"
    t.index ["section_id"], name: "index_grader_assignments_on_section_id"
  end

  create_table "grader_availabilities", force: :cascade do |t|
    t.integer "grader_id"
    t.string "weekday"
    t.integer "start"
    t.integer "end"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["grader_id"], name: "index_grader_availabilities_on_grader_id"
  end

  create_table "graders", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "currently_interested", default: false
    t.text "resume", default: ""
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "qualified_courses"
    t.string "interested_courses"
    t.index ["user_id"], name: "index_graders_on_user_id"
  end

  create_table "recommendations", force: :cascade do |t|
    t.text "letter"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "instructor_id"
    t.integer "grader_id"
    t.string "email"
    t.index ["grader_id"], name: "index_recommendations_on_grader_id"
    t.index ["instructor_id"], name: "index_recommendations_on_instructor_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.integer "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "section_schedules", force: :cascade do |t|
    t.string "weekday"
    t.integer "startTime"
    t.integer "endTime"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "section_id"
    t.index ["section_id"], name: "index_section_schedules_on_section_id"
  end

  create_table "sections", force: :cascade do |t|
    t.integer "sectionNumber"
    t.string "instructor"
    t.string "instructorEmail"
    t.string "term"
    t.string "buildingAndRoom"
    t.integer "numGradersNeeded", default: 1
    t.boolean "positionsOpen", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "course_id"
    t.integer "instructor_id"
    t.index ["course_id"], name: "index_sections_on_course_id"
    t.index ["instructor_id"], name: "index_sections_on_instructor_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_type"
    t.string "request"
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["request"], name: "index_users_on_request"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "recommendations", "users", column: "grader_id"
  add_foreign_key "recommendations", "users", column: "instructor_id"
  add_foreign_key "section_schedules", "sections"
  add_foreign_key "sections", "courses"
  add_foreign_key "sections", "users", column: "instructor_id"
end
