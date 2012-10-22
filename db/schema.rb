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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121022075849) do

  create_table "event_answers", :force => true do |t|
    t.integer "participation_id", :null => false
    t.integer "question_id",      :null => false
    t.string  "answer"
  end

  create_table "event_applications", :force => true do |t|
    t.integer "priority_1_id",                    :null => false
    t.integer "priority_2_id"
    t.integer "priority_3_id"
    t.boolean "approved",      :default => false, :null => false
    t.boolean "rejected",      :default => false, :null => false
    t.boolean "waiting_list",  :default => false, :null => false
  end

  create_table "event_dates", :force => true do |t|
    t.integer  "event_id",  :null => false
    t.string   "label"
    t.datetime "start_at"
    t.datetime "finish_at"
  end

  create_table "event_kinds", :force => true do |t|
    t.string   "label",       :null => false
    t.string   "short_name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.datetime "deleted_at"
    t.integer  "minimum_age"
  end

  create_table "event_kinds_preconditions", :force => true do |t|
    t.integer "event_kind_id",         :null => false
    t.integer "qualification_type_id", :null => false
  end

  create_table "event_kinds_prolongations", :force => true do |t|
    t.integer "event_kind_id",         :null => false
    t.integer "qualification_type_id", :null => false
  end

  create_table "event_kinds_qualification_types", :force => true do |t|
    t.integer "event_kind_id",         :null => false
    t.integer "qualification_type_id", :null => false
  end

  create_table "event_participations", :force => true do |t|
    t.integer  "event_id",                                  :null => false
    t.integer  "person_id",                                 :null => false
    t.text     "additional_information"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "active",                 :default => false, :null => false
    t.integer  "application_id"
    t.index ["event_id", "person_id"], :name => "index_event_participations_on_event_id_and_person_id", :unique => true
  end

  create_table "event_questions", :force => true do |t|
    t.integer "event_id"
    t.string  "question"
    t.string  "choices"
  end

  create_table "event_roles", :force => true do |t|
    t.string  "type",             :null => false
    t.integer "participation_id", :null => false
    t.string  "label"
  end

  create_table "events", :force => true do |t|
    t.integer  "group_id",                                                :null => false
    t.string   "type"
    t.string   "name",                                                    :null => false
    t.string   "number"
    t.string   "motto"
    t.string   "cost"
    t.integer  "maximum_participants"
    t.integer  "contact_id"
    t.text     "description"
    t.text     "location"
    t.date     "application_opening_at"
    t.date     "application_closing_at"
    t.text     "application_conditions"
    t.integer  "kind_id"
    t.string   "state",                  :limit => 60
    t.boolean  "priorization",                         :default => false, :null => false
    t.boolean  "requires_approval",                    :default => false, :null => false
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.integer  "participant_count",                    :default => 0
  end

  create_table "groups", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "name",                           :null => false
    t.string   "short_name",     :limit => 31
    t.string   "type",                           :null => false
    t.string   "email"
    t.string   "address",        :limit => 1024
    t.integer  "zip_code"
    t.string   "town"
    t.string   "country"
    t.integer  "contact_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.datetime "deleted_at"
    t.integer  "layer_group_id"
    t.index ["layer_group_id"], :name => "index_groups_on_layer_group_id"
    t.index ["parent_id"], :name => "index_groups_on_parent_id"
    t.index ["lft", "rgt"], :name => "index_groups_on_lft_and_rgt"
  end

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company_name"
    t.string   "nickname"
    t.boolean  "company",                                :default => false, :null => false
    t.string   "email"
    t.string   "address",                :limit => 1024
    t.integer  "zip_code"
    t.string   "town"
    t.string   "country"
    t.string   "gender",                 :limit => 1
    t.date     "birthday"
    t.text     "additional_information"
    t.boolean  "contact_data_visible",                   :default => false, :null => false
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.index ["reset_password_token"], :name => "index_people_on_reset_password_token", :unique => true
    t.index ["email"], :name => "index_people_on_email", :unique => true
  end

  create_table "people_filter_role_types", :force => true do |t|
    t.integer "people_filter_id"
    t.string  "role_type",        :null => false
  end

  create_table "people_filters", :force => true do |t|
    t.string  "name",       :null => false
    t.integer "group_id"
    t.string  "group_type"
    t.string  "kind",       :null => false
  end

  create_table "phone_numbers", :force => true do |t|
    t.integer "contactable_id",                     :null => false
    t.string  "contactable_type",                   :null => false
    t.string  "number",                             :null => false
    t.string  "label"
    t.boolean "public",           :default => true, :null => false
    t.index ["contactable_id", "contactable_type"], :name => "index_phone_numbers_on_contactable_id_and_contactable_type"
  end

  create_table "qualification_types", :force => true do |t|
    t.string   "label",                       :null => false
    t.integer  "validity"
    t.string   "description", :limit => 1023
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.datetime "deleted_at"
  end

  create_table "qualifications", :force => true do |t|
    t.integer "person_id",             :null => false
    t.integer "qualification_type_id", :null => false
    t.date    "start_at",              :null => false
    t.date    "finish_at"
  end

  create_table "roles", :force => true do |t|
    t.integer  "person_id",  :null => false
    t.integer  "group_id",   :null => false
    t.string   "type",       :null => false
    t.string   "label"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.datetime "deleted_at"
    t.index ["person_id", "group_id"], :name => "index_roles_on_person_id_and_group_id"
  end

  create_table "social_accounts", :force => true do |t|
    t.integer "contactable_id",                     :null => false
    t.string  "contactable_type",                   :null => false
    t.string  "name",                               :null => false
    t.string  "label"
    t.boolean "public",           :default => true, :null => false
    t.index ["contactable_id", "contactable_type"], :name => "index_social_accounts_on_contactable_id_and_contactable_type"
  end

end
