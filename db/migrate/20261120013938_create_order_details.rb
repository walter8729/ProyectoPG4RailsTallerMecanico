class CreateOrderDetails < ActiveRecord::Migration[8.1]
  def change
    create_table :order_details do |t|
      t.references :order, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1
      t.integer :unit_price, null: false, default: 0
      t.integer :subtotal, null: false, default: 0

      t.timestamps
    end
  end
end
