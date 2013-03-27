class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :tipos
      t.string :status
      t.string :nome
      t.string :endereco
      t.string :telefone
      t.string :modelo
      t.string :imei
      t.integer :admin_user_id
      t.datetime :data_saida
      t.decimal :total_price, :precision => 8, :scale => 2, :default => 0
      t.timestamps
    end
    add_index :orders, :admin_user_id
    add_index :orders, :nome
    add_index :orders, :modelo
    add_index :orders, :data_saida
  end

  def self.down
    drop_table :orders
  end
end