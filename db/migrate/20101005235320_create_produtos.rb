class CreateProdutos < ActiveRecord::Migration
  def self.up
    create_table :produtos do |t|
      t.integer :servico_id
      t.integer :quantidade,:default => 0
      t.string :unidade, :limit => 4
      t.string :descricao, :limit => 100
      t.decimal :price,:precision => 8, :scale => 2, :default => 0
      t.timestamps
    end
    add_index :produtos, :servico_id
  end

  def self.down
    drop_table :produtos
  end
end
