require "test_helper"

class CarsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @car = cars(:one)
  end

  test "should get index" do
    get cars_url
    assert_response :success
  end

  test "should get new" do
    get new_car_url
    assert_response :success
  end

  test "should create car" do
    assert_difference("Car.count") do
      post cars_url, params: {
        car: {
          brand: "Fiat",
          color: "Blanco",
          model: "Cronos",
          plate: "NEW001",
          chassis: "CHASISNEW001",
          mileage: 15000,
          year: 2022,
          customer_id: customers(:one).id
        }
      }
    end

    assert_redirected_to cars_url
  end

  test "should get edit" do
    get edit_car_url(@car)
    assert_response :success
  end

  test "should update car" do
    patch car_url(@car), params: {
      car: {
        brand: @car.brand,
        color: @car.color,
        model: @car.model,
        plate: @car.plate,
        year: @car.year,
        customer_id: @car.customer_id
      }
    }
    assert_redirected_to cars_url
  end

  test "should not destroy car with associated orders" do
    assert_no_difference("Car.count") do
      delete car_url(@car)
    end

    assert_redirected_to cars_url
    assert_equal "No se puede eliminar el auto porque tiene órdenes de trabajo asociadas.", flash[:alert]
  end

  test "should destroy car" do
    @car.orders.destroy_all
    assert_difference("Car.count", -1) do
      delete car_url(@car)
    end

    assert_redirected_to cars_url
  end
end
