class AddAdminToAdminUser < ActiveRecord::Migration
  def self.up
  	add_column :admin_users, :nome, :string
  	add_column :admin_users, :username, :string
    add_column :admin_users, :admin, :boolean, :default => false

  end

  def self.down
    remove_column :admin_users, :admin
  end
end
