class CreateMechanics < ActiveRecord::Migration[8.1]
  def change
    create_table :mechanics do |t|
      t.string :first_name
      t.string :last_name
      t.string :specialty
      t.string :phone

      t.timestamps
    end
  end
end
