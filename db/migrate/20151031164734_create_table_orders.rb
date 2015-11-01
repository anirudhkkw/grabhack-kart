class CreateTableOrders < ActiveRecord::Migration
  def change
    create_table :table_orders do |t|
      t.string :title, :limit => 255
      t.text :image
      t.text :url
      t.string :price
      t.timestamps
    end
  end
end
