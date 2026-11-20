class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :car, null: false, foreign_key: true
      t.date :order_date, null: false
      t.date :delivery_date
      t.string :status, null: false, default: "Pendiente"
      t.string :notes
      t.integer :total, null: false, default: 0

      t.timestamps
    end
  end
end
