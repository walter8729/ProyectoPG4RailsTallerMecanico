class AddDetailsToCustomers < ActiveRecord::Migration[8.1]
  def change
    add_column :customers, :document_type, :string, default: "CI"
    add_column :customers, :document_number, :string
    add_column :customers, :email, :string
    add_column :customers, :address, :string
    add_index :customers, :document_number, unique: true
  end
end
