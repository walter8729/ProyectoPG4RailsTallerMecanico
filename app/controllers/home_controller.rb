class HomeController < ApplicationController
  def index
    @customers_count = Customer.count
    @cars_count = Car.count
    @pending_orders_count = Order.where(status: "Pendiente").count
    @in_progress_orders_count = Order.where(status: "En Proceso").count
    @completed_orders_count = Order.where(status: "Completada").count
    @total_billed = Order.where(status: "Completada").sum(:total)

    @recent_orders = Order.includes(:car, :customer).ordered.limit(5)
  end
end
