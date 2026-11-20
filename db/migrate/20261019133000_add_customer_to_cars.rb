class AddCustomerToCars < ActiveRecord::Migration[8.1]
  class Car < ApplicationRecord
    self.table_name = "cars"
  end

  class Customer < ApplicationRecord
    self.table_name = "customers"
  end

  def up
    add_reference :cars, :customer, null: true, foreign_key: true

    customer = Customer.order(:id).first
    customer ||= Customer.create!(
      first_name: "Cliente",
      last_name: "Sin asignar"
    )

    Car.where(customer_id: nil).update_all(customer_id: customer.id)

    change_column_null :cars, :customer_id, false
  end

  def down
    remove_reference :cars, :customer, foreign_key: true
  end
end
