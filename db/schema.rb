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

ActiveRecord::Schema.define(version: 20180914140558) do

  create_table "attendance_statuses", force: :cascade do |t|
    t.string   "status"
    t.integer  "person_id"
    t.integer  "conference_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "attendance_statuses", ["conference_id"], name: "index_attendance_statuses_on_conference_id"
  add_index "attendance_statuses", ["person_id", "conference_id"], name: "index_attendance_statuses_on_person_id_and_conference_id", unique: true
  add_index "attendance_statuses", ["person_id"], name: "index_attendance_statuses_on_person_id"

  create_table "attendees", force: :cascade do |t|
    t.string   "status"
    t.integer  "person_id"
    t.integer  "conference_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "attendees", ["conference_id"], name: "index_attendees_on_conference_id"
  add_index "attendees", ["person_id"], name: "index_attendees_on_person_id"

  create_table "availabilities", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "conference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "day_id"
  end

  add_index "availabilities", ["conference_id"], name: "index_availabilities_on_conference_id"
  add_index "availabilities", ["person_id"], name: "index_availabilities_on_person_id"

  create_table "call_for_participations", force: :cascade do |t|
    t.date     "start_date",    null: false
    t.date     "end_date",      null: false
    t.date     "hard_deadline"
    t.text     "welcome_text"
    t.integer  "conference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "info_url"
    t.string   "contact_email"
  end

  add_index "call_for_participations", ["start_date", "end_date"], name: "index_call_for_papers_on_dates"

  create_table "conference_exports", force: :cascade do |t|
    t.string   "locale"
    t.integer  "conference_id"
    t.string   "tarball_file_name"
    t.string   "tarball_content_type"
    t.integer  "tarball_file_size"
    t.datetime "tarball_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conference_exports", ["conference_id"], name: "index_conference_exports_on_conference_id"

  create_table "conference_users", force: :cascade do |t|
    t.string   "role"
    t.integer  "user_id"
    t.integer  "conference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conference_users", ["conference_id"], name: "index_conference_users_on_conference_id"
  add_index "conference_users", ["user_id"], name: "index_conference_users_on_user_id"

  create_table "conferences", force: :cascade do |t|
    t.string   "acronym",                                                          null: false
    t.string   "title",                                                            null: false
    t.string   "timezone",                                  default: "Berlin",     null: false
    t.integer  "timeslot_duration",                         default: 15,           null: false
    t.integer  "default_timeslots",                         default: 3,            null: false
    t.integer  "max_timeslots",                             default: 20,           null: false
    t.boolean  "feedback_enabled",                          default: false,        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "program_export_base_url"
    t.string   "schedule_version"
    t.boolean  "schedule_public",                           default: false,        null: false
    t.string   "color"
    t.string   "ticket_type",                               default: "integrated"
    t.boolean  "event_state_visible",                       default: true
    t.text     "schedule_custom_css",       limit: 2097152
    t.text     "schedule_html_intro",       limit: 2097152
    t.string   "default_recording_license"
    t.boolean  "expenses_enabled",                          default: false,        null: false
    t.boolean  "transport_needs_enabled",                   default: false,        null: false
    t.integer  "parent_id"
    t.boolean  "bulk_notification_enabled",                 default: false,        null: false
  end

  add_index "conferences", ["acronym"], name: "index_conferences_on_acronym"
  add_index "conferences", ["parent_id"], name: "index_conferences_on_parent_id"

  create_table "conflicts", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "conflicting_event_id"
    t.integer  "person_id"
    t.string   "conflict_type"
    t.string   "severity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conflicts", ["event_id", "conflicting_event_id"], name: "index_conflicts_on_event_id"
  add_index "conflicts", ["person_id"], name: "index_conflicts_on_person_id"

  create_table "days", force: :cascade do |t|
    t.integer  "conference_id"
    t.datetime "start_date"
    t.datetime "end_date"
  end

  add_index "days", ["conference_id"], name: "index_days_on_conference"

  create_table "difs", force: :cascade do |t|
    t.string   "travel_support"
    t.boolean  "past_travel_assistance"
    t.boolean  "willing_to_facilitate"
    t.string   "status"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "person_id"
  end

  create_table "event_attachments", force: :cascade do |t|
    t.integer  "event_id",                               null: false
    t.string   "title",                                  null: false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public",                  default: true
  end

  add_index "event_attachments", ["event_id"], name: "index_event_attachments_on_event_id"

  create_table "event_feedbacks", force: :cascade do |t|
    t.integer  "event_id"
    t.float    "rating"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_feedbacks", ["event_id"], name: "index_event_feedbacks_on_event_id"

  create_table "event_people", force: :cascade do |t|
    t.integer  "event_id",                                               null: false
    t.integer  "person_id",                                              null: false
    t.string   "event_role",                       default: "submitter", null: false
    t.string   "role_state"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.string   "notification_subject", limit: 255
    t.text     "notification_body"
  end

  add_index "event_people", ["event_id"], name: "index_event_people_on_event_id"
  add_index "event_people", ["person_id"], name: "index_event_people_on_person_id"

  create_table "event_ratings", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "person_id"
    t.float    "rating"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_ratings", ["event_id"], name: "index_event_ratings_on_event_id"
  add_index "event_ratings", ["person_id"], name: "index_event_ratings_on_person_id"

  create_table "events", force: :cascade do |t|
    t.integer  "conference_id",                          null: false
    t.string   "title",                                  null: false
    t.string   "subtitle"
    t.string   "event_type",            default: "talk"
    t.integer  "time_slots"
    t.string   "state",                 default: "new",  null: false
    t.string   "language"
    t.datetime "start_time"
    t.text     "abstract"
    t.text     "description"
    t.boolean  "public",                default: true
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "track_id"
    t.integer  "room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "average_rating"
    t.integer  "event_ratings_count",   default: 0
    t.text     "note"
    t.text     "submission_note"
    t.integer  "speaker_count",         default: 0
    t.integer  "event_feedbacks_count", default: 0
    t.float    "average_feedback"
    t.string   "guid"
    t.boolean  "do_not_record",         default: false
    t.string   "recording_license"
    t.text     "tech_rider"
    t.text     "other_presenters"
    t.text     "desired_outcome"
    t.string   "theme"
    t.string   "skill_level"
    t.boolean  "travel_assistance"
    t.string   "iff_before"
    t.string   "etherpad_url"
    t.string   "public_type"
    t.string   "phone_number"
    t.string   "phone_prefix"
    t.boolean  "projector"
  end

  add_index "events", ["conference_id"], name: "index_events_on_conference_id"
  add_index "events", ["event_type"], name: "index_events_on_type"
  add_index "events", ["guid"], name: "index_events_on_guid", unique: true
  add_index "events", ["state"], name: "index_events_on_state"

  create_table "expenses", force: :cascade do |t|
    t.string   "name"
    t.decimal  "value",         precision: 7, scale: 2
    t.boolean  "reimbursed"
    t.integer  "person_id"
    t.integer  "conference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "expenses", ["conference_id"], name: "index_expenses_on_conference_id"
  add_index "expenses", ["person_id"], name: "index_expenses_on_person_id"

  create_table "im_accounts", force: :cascade do |t|
    t.integer  "person_id"
    t.string   "im_type"
    t.string   "im_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "im_accounts", ["person_id"], name: "index_im_accounts_on_person_id"

  create_table "invites", force: :cascade do |t|
    t.integer "person_id"
    t.integer "conference_id"
    t.string  "email"
  end

  add_index "invites", ["conference_id"], name: "index_invites_on_conference_id"
  add_index "invites", ["person_id"], name: "index_invites_on_person_id"

  create_table "languages", force: :cascade do |t|
    t.string   "code"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "languages", ["attachable_id"], name: "index_languages_on_attachable_id"

  create_table "links", force: :cascade do |t|
    t.string   "title",         null: false
    t.string   "url",           null: false
    t.integer  "linkable_id",   null: false
    t.string   "linkable_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "links", ["linkable_id"], name: "index_links_on_linkable_id"

  create_table "mail_templates", force: :cascade do |t|
    t.integer  "conference_id"
    t.string   "name"
    t.string   "subject"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mail_templates", ["conference_id"], name: "index_mail_templates_on_conference_id"

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "locale"
    t.string   "accept_subject"
    t.string   "reject_subject"
    t.text     "accept_body"
    t.text     "reject_body"
    t.integer  "conference_id"
    t.string   "schedule_subject", limit: 255
    t.text     "schedule_body"
  end

  create_table "people", force: :cascade do |t|
    t.string   "first_name",               default: ""
    t.string   "last_name",                default: ""
    t.string   "public_name"
    t.string   "email",                                    null: false
    t.boolean  "email_public",             default: true
    t.string   "gender"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.text     "abstract"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.text     "note"
    t.boolean  "include_in_mailings",      default: true,  null: false
    t.text     "pgp_key"
    t.string   "country_of_origin"
    t.string   "professional_background"
    t.text     "other_background"
    t.string   "organization"
    t.string   "project"
    t.string   "title"
    t.string   "iff_before"
    t.boolean  "invitation_to_mattermost", default: true,  null: false
    t.boolean  "interested_in_volunteer",  default: true,  null: false
    t.text     "iff_goals"
    t.text     "challenges"
    t.text     "other_resources"
    t.boolean  "already_mailing"
    t.boolean  "already_mattermost"
    t.string   "twitter"
    t.string   "personal_website"
    t.string   "complete_mailing"
    t.string   "complete_mattermost"
    t.boolean  "late_event_submit",        default: false
    t.string   "old_attendance_status"
    t.string   "gender_pronoun"
    t.string   "iff_days"
    t.string   "email_confirm"
    t.boolean  "group"
  end

  add_index "people", ["email"], name: "index_people_on_email"
  add_index "people", ["user_id"], name: "index_people_on_user_id"

  create_table "phone_numbers", force: :cascade do |t|
    t.integer  "person_id"
    t.string   "phone_type"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phone_numbers", ["person_id"], name: "index_phone_numbers_on_person_id"

  create_table "rooms", force: :cascade do |t|
    t.integer  "conference_id", null: false
    t.string   "name",          null: false
    t.integer  "size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rank"
  end

  add_index "rooms", ["conference_id"], name: "index_rooms_on_conference_id"

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "ticket_servers", force: :cascade do |t|
    t.integer  "conference_id", null: false
    t.string   "url"
    t.string   "user"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue"
  end

  create_table "tickets", force: :cascade do |t|
    t.integer  "object_id",        null: false
    t.string   "remote_ticket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "object_type"
  end

  add_index "tickets", ["object_id"], name: "index_tickets_on_object_id"

  create_table "tracks", force: :cascade do |t|
    t.integer  "conference_id"
    t.string   "name",                             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "color",         default: "fefd7f"
  end

  add_index "tracks", ["conference_id"], name: "index_tracks_on_conference_id"

  create_table "transport_needs", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "conference_id"
    t.datetime "at"
    t.string   "transport_type"
    t.integer  "seats"
    t.boolean  "booked"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transport_needs", ["conference_id"], name: "index_transport_needs_on_conference_id"
  add_index "transport_needs", ["person_id"], name: "index_transport_needs_on_person_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                         default: "",          null: false
    t.string   "password_digest",               default: "",          null: false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.string   "remember_token"
    t.integer  "sign_in_count",                 default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",                          default: "submitter"
    t.string   "pentabarf_salt"
    t.string   "pentabarf_password"
    t.string   "confirm_attendance_token"
    t.datetime "confirm_attendance_email_sent"
    t.datetime "email_sent_to_confirmed_only"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",                       null: false
    t.integer  "item_id",                         null: false
    t.string   "event",                           null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.integer  "conference_id"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.text     "object_changes",  limit: 4194304
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"

  create_table "videos", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "url"
    t.string   "mimetype"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "videos", ["event_id"], name: "index_videos_on_event_id"

end
