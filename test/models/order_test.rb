require "test_helper"

class OrderTest < ActiveSupport::TestCase
  setup do
    @car = cars(:one)
  end

  test "valida que fecha de entrega no sea anterior a la fecha de ingreso" do
    order = Order.new(
      car: @car,
      order_date: Date.current,
      delivery_date: Date.yesterday,
      status: "Pendiente"
    )
    assert_not order.valid?
    assert_includes order.errors[:delivery_date], "no puede ser anterior a la fecha de ingreso (#{Date.current.strftime('%d/%m/%Y')})"

    # Entrega el mismo día debe ser VÁLIDA (servicios rápidos / entrega en el día)
    order.delivery_date = Date.current
    assert order.valid?

    # Entrega posterior también es VÁLIDA
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
