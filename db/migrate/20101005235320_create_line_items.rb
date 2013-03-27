class CreateLineItems < ActiveRecord::Migration
  def self.up
    create_table :line_items do |t|
      t.integer :order_id
      t.integer :quantidade,:default => 0
      t.string :unidade, :limit => 4
      t.string :descricao, :limit => 100
      t.decimal :price,:precision => 8, :scale => 2, :default => 0
      t.timestamps
    end
    add_index :line_items, :order_id
  end

  def self.down
    drop_table :line_items
  end
end
