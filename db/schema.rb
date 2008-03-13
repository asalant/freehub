# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 7) do

  create_table "delete_mes", :force => true do |t|
    t.string   "foo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.string   "key"
    t.string   "timezone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organizations", ["key"], :name => "index_organizations_key", :unique => true

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "full_name"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "country"
    t.string   "email"
    t.string   "phone"
    t.boolean  "staff"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.integer  "organization_id"
  end

  add_index "people", ["created_by_id"], :name => "fk_people_created_by"
  add_index "people", ["updated_by_id"], :name => "fk_people_updated_by"
  add_index "people", ["organization_id"], :name => "fk_people_organization"

  create_table "roles", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "authorizable_type", :limit => 40
    t.integer  "authorizable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "paid"
    t.boolean  "volunteered"
    t.text     "note"
    t.integer  "service_type_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
  end

  add_index "services", ["created_by_id"], :name => "fk_services_created_by"
  add_index "services", ["updated_by_id"], :name => "fk_services_updated_by"
  add_index "services", ["service_type_id"], :name => "fk_services_service_type"
  add_index "services", ["person_id"], :name => "fk_services_person"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "name"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "visits", :force => true do |t|
    t.datetime "datetime"
    t.boolean  "volunteer",     :default => false
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.integer  "person_id"
  end

  add_index "visits", ["created_by_id"], :name => "fk_visits_created_by"
  add_index "visits", ["updated_by_id"], :name => "fk_visits_updated_by"
  add_index "visits", ["person_id"], :name => "fk_visits_person"

end
