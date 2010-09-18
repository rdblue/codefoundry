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

ActiveRecord::Schema.define(:version => 20100914210522) do

  create_table "privs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_privileges", :force => true do |t|
    t.integer  "role_id"
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "summary"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "param"
    t.integer  "hits",                :default => 0
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "projects", ["param"], :name => "index_projects_on_param"

  create_table "repositories", :force => true do |t|
    t.string   "path"
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "scm"
    t.string   "summary"
    t.string   "param"
  end

  add_index "repositories", ["param"], :name => "index_repositories_on_param"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone"
  end

end
