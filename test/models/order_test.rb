require "test_helper"

class OrderTest < ActiveSupport::TestCase
  setup do
    @car = cars(:one)
  end

  test "valida que fecha de entrega sea posterior a fecha de ingreso" do
    order = Order.new(
      car: @car,
      order_date: Date.current,
      delivery_date: Date.current,
      status: "Pendiente"
    )
    assert_not order.valid?
    assert_includes order.errors[:delivery_date], "debe ser posterior a la fecha de ingreso (#{Date.current.strftime('%d/%m/%Y')})"

    # Con fecha anterior también debe ser inválido
    order.delivery_date = Date.yesterday
    assert_not order.valid?

    # Con fecha estrictamente posterior debe ser válido
    order.delivery_date = Date.tomorrow
    assert order.valid?
  end

  test "permite fecha de entrega en blanco al crear orden pendiente" do
    order = Order.new(
      car: @car,
      order_date: Date.current,
      delivery_date: nil,
      status: "Pendiente"
    )
    assert order.valid?
  end
end
