class DropCarts < ActiveRecord::Migration[8.1]
  def change
    drop_table :carts, if_exists: true
  end
end
