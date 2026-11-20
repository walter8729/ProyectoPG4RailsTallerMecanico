class CustomersController < ApplicationController
  def index
    customers = Customer.ordered.order(:id)

    if params[:q].present?
      criterio = "%#{params[:q]}%".downcase
      customers = customers.where(
        "lower(first_name) LIKE :q OR lower(last_name) LIKE :q OR lower(phone) LIKE :q",
        q: criterio
      )
    end

    @pagy, @customers = pagy(:offset, customers)
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    @customer.save
    redirect_to clientes_path
  end

  def edit
    @customer = Customer.includes(:cars).find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    @customer.update(customer_params)
    redirect_to clientes_path
  end

  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy
    redirect_to clientes_path
  end

  private

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :phone)
  end
end
