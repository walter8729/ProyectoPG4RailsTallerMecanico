class CreateAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :assignments do |t|
      t.references :order, null: false, foreign_key: true
      t.references :mechanic, null: false, foreign_key: true
      t.date :assigned_at, null: false

      t.timestamps
    end
    add_index :assignments, [:order_id, :mechanic_id], unique: true
  end
end
