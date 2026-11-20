require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
    @car = cars(:one)
    @service = services(:one)
    @mechanic = mechanics(:one)
  end

  test "should get index" do
    get orders_url
    assert_response :success
  end

  test "should get new" do
    get new_order_url
    assert_response :success
  end

  test "should create order" do
    assert_difference("Order.count") do
      post orders_url, params: {
        order: {
          car_id: @car.id,
          order_date: Date.current,
          status: "Pendiente",
          notes: "Cambio de pastillas"
        },
        mechanic_ids: [@mechanic.id],
        order_services: {
          "0" => { service_id: @service.id, quantity: 1, unit_price: @service.price }
        }
      }
    end

    assert_redirected_to order_url(Order.last)
  end

  test "should show order" do
    get order_url(@order)
    assert_response :success
  end

  test "should get edit" do
    get edit_order_url(@order)
    assert_response :success
  end

  test "should update order" do
    patch order_url(@order), params: {
      order: {
        status: "En Proceso",
        notes: "En reparación de frenos"
      }
    }
    assert_redirected_to order_url(@order)
  end

  test "should update status via action" do
    patch update_status_order_url(@order), params: { status: "Completada" }
    assert_redirected_to order_url(@order)
    assert_equal "Completada", @order.reload.status
  end

  test "should destroy order" do
    assert_difference("Order.count", -1) do
      delete order_url(@order)
    end

    assert_redirected_to orders_url
  end
end
