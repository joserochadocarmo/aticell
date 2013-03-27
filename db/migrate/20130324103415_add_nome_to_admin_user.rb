class AddNomeToAdminUser < ActiveRecord::Migration
  def self.up
    add_column :admin_users, :nome, :string
  end

  def self.down
    remove_column :admin_users, :nome
  end
end
