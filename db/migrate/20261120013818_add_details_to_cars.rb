class AddDetailsToCars < ActiveRecord::Migration[8.1]
  def change
    add_column :cars, :chassis, :string
    add_column :cars, :mileage, :integer, default: 0
    add_index :cars, :plate, unique: true
    add_index :cars, :chassis, unique: true
  end
end
