class CreateServicos < ActiveRecord::Migration
  def self.up
    create_table :servicos do |t|
      t.string :tipos
      t.string :status
      t.string :nome
      t.string :endereco
      t.string :telefone
      t.string :modelo
      t.string :imei
      t.integer :admin_user_id
      t.datetime :data_saida
      t.boolean :entrega
      t.decimal :total_price, :precision => 8, :scale => 2, :default => 0
      t.timestamps
    end
    add_index :servicos, :admin_user_id
    add_index :servicos, :nome
    add_index :servicos, :modelo
    add_index :servicos, :data_saida
  end

  def self.down
    drop_table :servicos
  end
end