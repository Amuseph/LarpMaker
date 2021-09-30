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

ActiveRecord::Schema.define(version: 2021_09_30_015508) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "backstories", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.string "backstory"
    t.boolean "approved", default: false, null: false
    t.boolean "locked", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id"], name: "index_backstories_on_character_id"
  end

  create_table "banklogs", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.datetime "acquiredate", default: -> { "CURRENT_TIMESTAMP" }
    t.string "name", null: false
    t.integer "amount", null: false
    t.bigint "grantedby_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id"], name: "index_banklogs_on_character_id"
    t.index ["grantedby_id"], name: "index_banklogs_on_grantedby_id"
  end

  create_table "cabins", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "playeravailable", null: false
    t.boolean "castavailable", null: false
    t.string "location", null: false
    t.integer "maxplayers", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "characterclasses", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "playeravailable", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "shortdescription"
  end

  create_table "characterclassskillgroups", force: :cascade do |t|
    t.bigint "skillgroup_id", null: false
    t.bigint "characterclass_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["characterclass_id"], name: "index_characterclassskillgroups_on_characterclass_id"
    t.index ["skillgroup_id"], name: "index_characterclassskillgroups_on_skillgroup_id"
  end

  create_table "characterprofessions", force: :cascade do |t|
    t.bigint "profession_id", null: false
    t.bigint "character_id", null: false
    t.date "acquiredate", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id", "profession_id"], name: "index_characterprofessions_on_character_id_and_profession_id", unique: true
    t.index ["character_id"], name: "index_characterprofessions_on_character_id"
    t.index ["profession_id"], name: "index_characterprofessions_on_profession_id"
  end

  create_table "characters", force: :cascade do |t|
    t.string "name", null: false
    t.string "pronouns", null: false
    t.integer "level", default: 1, null: false
    t.string "totem"
    t.string "status", default: "Active"
    t.date "levelupdate", default: -> { "CURRENT_TIMESTAMP" }
    t.date "createdate", default: -> { "CURRENT_TIMESTAMP" }
    t.bigint "user_id", null: false
    t.bigint "deity_id"
    t.bigint "race_id", null: false
    t.bigint "characterclass_id", null: false
    t.bigint "house_id"
    t.bigint "guild_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "alias"
    t.index ["characterclass_id"], name: "index_characters_on_characterclass_id"
    t.index ["deity_id"], name: "index_characters_on_deity_id"
    t.index ["guild_id"], name: "index_characters_on_guild_id"
    t.index ["house_id"], name: "index_characters_on_house_id"
    t.index ["race_id"], name: "index_characters_on_race_id"
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "characterskills", force: :cascade do |t|
    t.string "details"
    t.bigint "skill_id", null: false
    t.bigint "character_id", null: false
    t.date "acquiredate", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id"], name: "index_characterskills_on_character_id"
    t.index ["skill_id"], name: "index_characterskills_on_skill_id"
  end

  create_table "couriers", force: :cascade do |t|
    t.string "recipient", null: false
    t.string "destination", null: false
    t.string "message", null: false
    t.date "senddate", default: -> { "CURRENT_TIMESTAMP" }
    t.bigint "character_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "couriertype", null: false
    t.integer "skillsused", null: false
    t.index ["character_id"], name: "index_couriers_on_character_id"
  end

  create_table "deities", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "playeravailable", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "shortdescription"
  end

  create_table "eventattendances", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "registrationtype", null: false
    t.datetime "registerdate", default: -> { "CURRENT_TIMESTAMP" }
    t.bigint "user_id", null: false
    t.bigint "character_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "cabin_id"
    t.string "mealplan"
    t.index ["character_id", "event_id"], name: "index_eventattendances_on_character_id_and_event_id", unique: true
    t.index ["character_id"], name: "index_eventattendances_on_character_id"
    t.index ["event_id", "user_id"], name: "index_eventattendances_on_event_id_and_user_id", unique: true
    t.index ["event_id"], name: "index_eventattendances_on_event_id"
    t.index ["user_id"], name: "index_eventattendances_on_user_id"
  end

  create_table "eventfeedbacks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "character_id"
    t.bigint "event_id", null: false
    t.integer "preeventcommunicationrating", null: false
    t.integer "eventrating", null: false
    t.integer "attendnextevent", null: false
    t.integer "sleepingrating", null: false
    t.integer "openingmeetingrating", null: false
    t.integer "closingmeetingrating", null: false
    t.integer "plotrating", null: false
    t.string "feedback", null: false
    t.string "questions", null: false
    t.string "standoutplayers", null: false
    t.string "standoutnpc", null: false
    t.string "charactergoals", null: false
    t.string "charactergoalactions", null: false
    t.string "whatdidyoudo", null: false
    t.string "nexteventplans", null: false
    t.string "professions", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id"], name: "index_eventfeedbacks_on_character_id"
    t.index ["event_id"], name: "index_eventfeedbacks_on_event_id"
    t.index ["user_id"], name: "index_eventfeedbacks_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.string "eventtype", null: false
    t.string "location", null: false
    t.date "startdate", null: false
    t.date "enddate", null: false
    t.string "description", null: false
    t.integer "atdoorcost", default: 0
    t.integer "earlybirdcost", default: 0
    t.integer "eventexp", default: 300
    t.integer "feedbackexp", default: 100
    t.boolean "levelingevent", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "playercount", null: false
    t.integer "castcount", null: false
    t.boolean "mealplan", null: false
    t.integer "mealplancost"
    t.text "mealplandetails"
    t.integer "newplayerprice", null: false
  end

  create_table "explogs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "acquiredate", default: -> { "CURRENT_TIMESTAMP" }
    t.string "name", null: false
    t.string "description", null: false
    t.integer "amount", null: false
    t.bigint "grantedby_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["grantedby_id"], name: "index_explogs_on_grantedby_id"
    t.index ["user_id"], name: "index_explogs_on_user_id"
  end

  create_table "guilds", force: :cascade do |t|
    t.string "name", null: false
    t.date "createdate", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "houses", force: :cascade do |t|
    t.string "name", null: false
    t.date "createdate", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "fledglingbenefit"
    t.string "fledglingplot"
    t.string "establishedbenefit"
    t.string "establishedplot"
    t.string "bannerbenefit"
    t.integer "thane_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "description"
    t.string "token"
    t.integer "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "professiongroups", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.boolean "playeravailable", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "professionrequirements", force: :cascade do |t|
    t.bigint "profession_id", null: false
    t.bigint "requiredprofession_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["profession_id"], name: "index_professionrequirements_on_profession_id"
    t.index ["requiredprofession_id"], name: "index_professionrequirements_on_requiredprofession_id"
  end

  create_table "professions", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.string "rank", null: false
    t.bigint "professiongroup_id", null: false
    t.boolean "playeravailable", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["professiongroup_id"], name: "index_professions_on_professiongroup_id"
  end

  create_table "races", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "playeravailable", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "shortdescription"
  end

  create_table "resttypes", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.boolean "playeravailable", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "rulebookchanges", force: :cascade do |t|
    t.integer "page", null: false
    t.string "change", null: false
    t.date "changedate", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "version", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["var"], name: "index_settings_on_var", unique: true
  end

  create_table "skilldeliveries", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.boolean "playeravailable", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "skillgroups", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "playeravailable", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "skillrequirements", force: :cascade do |t|
    t.bigint "skill_id", null: false
    t.bigint "requiredskill_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["requiredskill_id"], name: "index_skillrequirements_on_requiredskill_id"
    t.index ["skill_id"], name: "index_skillrequirements_on_skill_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.string "incant"
    t.string "target"
    t.string "prop"
    t.integer "tier", null: false
    t.integer "maxpurchase", null: false
    t.boolean "playeravailable"
    t.bigint "skillgroup_id", null: false
    t.bigint "resttype_id", null: false
    t.bigint "skilldelivery_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["resttype_id"], name: "index_skills_on_resttype_id"
    t.index ["skilldelivery_id"], name: "index_skills_on_skilldelivery_id"
    t.index ["skillgroup_id"], name: "index_skills_on_skillgroup_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "firstname", null: false
    t.string "lastname", null: false
    t.string "usertype", default: "Player"
    t.integer "charactercount", default: 1
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "last_character"
    t.string "aliaslastname"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "worldareas", force: :cascade do |t|
    t.string "region", null: false
    t.string "name", null: false
    t.string "description", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "backstories", "characters"
  add_foreign_key "banklogs", "characters"
  add_foreign_key "banklogs", "users", column: "grantedby_id"
  add_foreign_key "characterclassskillgroups", "characterclasses"
  add_foreign_key "characterclassskillgroups", "skillgroups"
  add_foreign_key "characterprofessions", "characters"
  add_foreign_key "characterprofessions", "professions"
  add_foreign_key "characters", "characterclasses"
  add_foreign_key "characters", "deities"
  add_foreign_key "characters", "guilds"
  add_foreign_key "characters", "houses"
  add_foreign_key "characters", "races"
  add_foreign_key "characters", "users"
  add_foreign_key "characterskills", "characters"
  add_foreign_key "characterskills", "skills"
  add_foreign_key "couriers", "characters"
  add_foreign_key "eventattendances", "cabins"
  add_foreign_key "eventattendances", "characters"
  add_foreign_key "eventattendances", "events"
  add_foreign_key "eventattendances", "users"
  add_foreign_key "eventfeedbacks", "characters"
  add_foreign_key "eventfeedbacks", "events"
  add_foreign_key "eventfeedbacks", "users"
  add_foreign_key "explogs", "users"
  add_foreign_key "explogs", "users", column: "grantedby_id"
  add_foreign_key "houses", "characters", column: "thane_id"
  add_foreign_key "orders", "users"
  add_foreign_key "professionrequirements", "professions"
  add_foreign_key "professionrequirements", "professions", column: "requiredprofession_id"
  add_foreign_key "professions", "professiongroups"
  add_foreign_key "skillrequirements", "skills"
  add_foreign_key "skillrequirements", "skills", column: "requiredskill_id"
  add_foreign_key "skills", "resttypes"
  add_foreign_key "skills", "skilldeliveries"
  add_foreign_key "skills", "skillgroups"
end
