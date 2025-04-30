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

ActiveRecord::Schema[8.1].define(version: 2025_04_30_050220) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.integer "author_id"
    t.string "author_type"
    t.text "body"
    t.datetime "created_at", null: false
    t.string "namespace"
    t.integer "resource_id"
    t.string "resource_type"
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "address", null: false
    t.integer "addressable_id", null: false
    t.string "addressable_type", null: false
    t.datetime "created_at", null: false
    t.string "label", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable"
  end

  create_table "admin_users", force: :cascade do |t|
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "language_preference", default: "en", null: false
    t.string "last_name"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "admin_users_roles", id: false, force: :cascade do |t|
    t.integer "admin_user_id"
    t.integer "role_id"
    t.index ["admin_user_id", "role_id"], name: "index_admin_users_roles_on_admin_user_id_and_role_id"
    t.index ["admin_user_id"], name: "index_admin_users_roles_on_admin_user_id"
    t.index ["role_id"], name: "index_admin_users_roles_on_role_id"
  end

  create_table "blazer_audits", force: :cascade do |t|
    t.datetime "created_at"
    t.string "data_source"
    t.integer "query_id"
    t.text "statement"
    t.integer "user_id"
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.string "check_type"
    t.datetime "created_at", null: false
    t.integer "creator_id"
    t.text "emails"
    t.datetime "last_run_at"
    t.text "message"
    t.integer "query_id"
    t.string "schedule"
    t.text "slack_channels"
    t.string "state"
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "dashboard_id"
    t.integer "position"
    t.integer "query_id"
    t.datetime "updated_at", null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "creator_id"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "creator_id"
    t.string "data_source"
    t.text "description"
    t.string "name"
    t.text "statement"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "contact_messages", force: :cascade do |t|
    t.integer "contact_id", null: false
    t.datetime "created_at", null: false
    t.string "message", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_contact_messages_on_contact_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.boolean "subscribed", default: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_contacts_on_email", unique: true
  end

  create_table "emails", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.integer "emailable_id", null: false
    t.string "emailable_type", null: false
    t.string "label", null: false
    t.datetime "updated_at", null: false
    t.index ["emailable_type", "emailable_id"], name: "index_emails_on_emailable"
  end

  create_table "events", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "end_day"
    t.string "end_time"
    t.integer "eventable_id", null: false
    t.string "eventable_type", null: false
    t.string "label"
    t.string "start_day"
    t.string "start_time"
    t.datetime "updated_at", null: false
    t.index ["eventable_type", "eventable_id"], name: "index_events_on_eventable"
  end

  create_table "exception_tracks", force: :cascade do |t|
    t.text "body", limit: 16777215
    t.datetime "created_at", precision: nil, null: false
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "flipper_features", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_flipper_features_on_key", unique: true
  end

  create_table "flipper_gates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "feature_key", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.text "value"
    t.index ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true
  end

  create_table "noticed_events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "notifications_count"
    t.json "params"
    t.bigint "record_id"
    t.string "record_type"
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id"], name: "index_noticed_events_on_record"
  end

  create_table "noticed_notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "event_id", null: false
    t.datetime "read_at", precision: nil
    t.bigint "recipient_id", null: false
    t.string "recipient_type", null: false
    t.datetime "seen_at", precision: nil
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_noticed_notifications_on_event_id"
    t.index ["recipient_type", "recipient_id"], name: "index_noticed_notifications_on_recipient"
  end

  create_table "phones", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "label", null: false
    t.string "phone", null: false
    t.integer "phoneable_id", null: false
    t.string "phoneable_type", null: false
    t.datetime "updated_at", null: false
    t.index ["phoneable_type", "phoneable_id"], name: "index_phones_on_phoneable"
  end

  create_table "products", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "discount_percent"
    t.string "options"
    t.integer "position", null: false
    t.string "price"
    t.integer "productable_id", null: false
    t.string "productable_type", null: false
    t.boolean "recommended", default: false, null: false
    t.string "recommended_text", default: "Chef's Selection", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["productable_id", "productable_type", "category", "position"], name: "idx_on_productable_id_productable_type_category_pos_2bfebd940b", unique: true
    t.index ["productable_type", "productable_id"], name: "index_products_on_productable"
  end

  create_table "restaurants", force: :cascade do |t|
    t.text "about_text"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.text "hero_text"
    t.string "name"
    t.boolean "primary", default: true, null: false
    t.string "slogan"
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "resource_id"
    t.string "resource_type"
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "rules", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.json "days_of_week", default: [], null: false
    t.date "end_date"
    t.integer "frequency"
    t.string "frequency_units"
    t.string "name"
    t.string "rule_hour_end"
    t.string "rule_hour_start"
    t.string "rule_type"
    t.integer "schedule_id", null: false
    t.date "start_date"
    t.datetime "updated_at", null: false
    t.index ["schedule_id"], name: "index_rules_on_schedule_id"
  end

  create_table "schedule_events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "event_time"
    t.integer "schedule_id", null: false
    t.datetime "updated_at", null: false
    t.index ["schedule_id"], name: "index_schedule_events_on_schedule_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.boolean "active", default: false, null: false
    t.string "beginning_of_week", default: "monday"
    t.integer "capacity", default: 1
    t.datetime "created_at", null: false
    t.boolean "exclude_lunch_time", default: true
    t.string "lunch_hour_end"
    t.string "lunch_hour_start"
    t.string "name", null: false
    t.integer "scheduleable_id", null: false
    t.string "scheduleable_type", null: false
    t.string "time_zone"
    t.datetime "updated_at", null: false
    t.index ["scheduleable_type", "scheduleable_id"], name: "index_schedules_on_scheduleable"
  end

  create_table "socials", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "icon", null: false
    t.string "name", null: false
    t.integer "socialable_id", null: false
    t.string "socialable_type", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.index ["socialable_type", "socialable_id"], name: "index_socials_on_socialable"
  end

  create_table "stores", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.string "name"
    t.boolean "primary", default: true
    t.string "slogan"
    t.datetime "updated_at", null: false
  end

  create_table "todos", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "category"
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "position", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "contact_messages", "contacts"
  add_foreign_key "rules", "schedules"
  add_foreign_key "schedule_events", "schedules"
end
