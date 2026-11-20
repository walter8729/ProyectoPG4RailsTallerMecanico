class HomeController < ApplicationController
  def index
    @customers_count = Customer.count
    @cars_count = Car.count
  end
end
