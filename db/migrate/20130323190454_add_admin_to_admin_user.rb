class AddAdminToAdminUser < ActiveRecord::Migration
  def self.up
  	add_column :admin_users, :username, :string
    add_column :admin_users, :admin, :boolean, :default => false

    # Create a default admin user
    AdminUser.create!(:email => 'admin@example.com',:username => 'admin',:nome => 'admin', :password => 'password', :password_confirmation => 'password',:admin => true)
  end

  def self.down
    remove_column :admin_users, :admin
  end
end
