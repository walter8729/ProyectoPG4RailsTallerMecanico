class CreateCarts < ActiveRecord::Migration[8.1]
  def change
    create_table :carts do |t|
      t.string :color
      t.string :plate_number
      t.string :brand
      t.boolean :active

      t.timestamps
    end
  end
end
