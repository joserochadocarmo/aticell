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

ActiveRecord::Schema.define(:version => 20130323190454) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nome"
    t.string   "username"
    t.boolean  "admin",                               :default => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "produtos", :force => true do |t|
    t.integer  "servico_id"
    t.integer  "quantidade",                                              :default => 0
    t.string   "unidade",    :limit => 4
    t.string   "descricao",  :limit => 100
    t.decimal  "price",                     :precision => 8, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "produtos", ["servico_id"], :name => "index_produtos_on_servico_id"

  create_table "servicos", :force => true do |t|
    t.string   "tipos"
    t.string   "status"
    t.string   "nome"
    t.string   "endereco"
    t.string   "telefone"
    t.string   "modelo"
    t.string   "imei"
    t.integer  "admin_user_id"
    t.datetime "data_saida"
    t.boolean  "entrega"
    t.decimal  "total_price",   :precision => 8, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "servicos", ["admin_user_id"], :name => "index_servicos_on_admin_user_id"
  add_index "servicos", ["data_saida"], :name => "index_servicos_on_data_saida"
  add_index "servicos", ["modelo"], :name => "index_servicos_on_modelo"
  add_index "servicos", ["nome"], :name => "index_servicos_on_nome"

end
