class CreateCars < ActiveRecord::Migration[8.1]
  def change
    create_table :cars do |t|
      t.string :brand
      t.string :model
      t.integer :year
      t.string :plate
      t.string :color

      t.timestamps
    end
  end
end
