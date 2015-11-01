class RenameTable < ActiveRecord::Migration
  def change
    rename_table :table_orders, :orders
  end
end
