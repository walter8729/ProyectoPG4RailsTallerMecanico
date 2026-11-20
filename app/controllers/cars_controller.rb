class CarsController < ApplicationController
  before_action :set_car, only: %i[ edit update destroy ]
  before_action :load_customers_for_form, only: %i[ new create edit update ]

  def index
    @cars = Car.includes(:customer).order(:brand, :model)
  end

  def new
    @car = Car.new(customer_id: params[:customer_id])
  end

  def edit
  end

  def create
    @car = Car.new(car_params)

    if @car.save
      redirect_to cars_path, notice: "Auto guardado correctamente."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @car.update(car_params)
      redirect_to cars_path, notice: "Auto actualizado correctamente."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @car.destroy!
    redirect_to cars_path, notice: "Auto eliminado.", status: :see_other
  end

  private

  def set_car
    @car = Car.find(params.expect(:id))
  end

  def car_params
    params.expect(car: [ :brand, :model, :year, :plate, :color, :customer_id, :chassis, :mileage ])
  end

  def load_customers_for_form
    @customers = Customer.ordered
  end
end
