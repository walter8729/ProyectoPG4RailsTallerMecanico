require "test_helper"

class MechanicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mechanic = mechanics(:one)
  end

  test "should get index" do
    get mechanics_url
    assert_response :success
  end

  test "should get new" do
    get new_mechanic_url
    assert_response :success
  end

  test "should create mechanic" do
    assert_difference("Mechanic.count") do
      post mechanics_url, params: {
        mechanic: {
          first_name: "Luis",
          last_name: "Ramírez",
          specialty: "Inyección Electrónica",
          phone: "0983 555 666"
        }
      }
    end

    assert_redirected_to mechanics_url
  end

  test "should get edit" do
    get edit_mechanic_url(@mechanic)
    assert_response :success
  end

  test "should update mechanic" do
    patch mechanic_url(@mechanic), params: {
      mechanic: {
        first_name: "Carlos Alberto",
        specialty: "Jefe de Taller"
      }
    }
    assert_redirected_to mechanics_url
  end

  test "should destroy mechanic" do
    @mechanic.assignments.destroy_all
    assert_difference("Mechanic.count", -1) do
      delete mechanic_url(@mechanic)
    end

    assert_redirected_to mechanics_url
  end
end
