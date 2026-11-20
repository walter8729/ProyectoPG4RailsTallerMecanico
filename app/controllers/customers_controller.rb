class CustomersController < ApplicationController
  before_action :set_customer, only: %i[show edit update destroy]

  def index
    customers = Customer.ordered

    if params[:q].present?
      criterio = "%#{params[:q]}%".downcase
      customers = customers.where(
        "lower(first_name) LIKE :q OR lower(last_name) LIKE :q OR lower(phone) LIKE :q OR lower(document_number) LIKE :q",
        q: criterio
      )
    end

    @pagy, @customers = pagy(:offset, customers)
  end

  def show
    # @customer ya cargado con sus autos por before_action
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      redirect_to cliente_path(@customer), notice: "Cliente registrado correctamente."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @customer.update(customer_params)
      redirect_to cliente_path(@customer), notice: "Cliente actualizado correctamente."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @customer.destroy
      redirect_to clientes_path, notice: "Cliente eliminado correctamente.", status: :see_other
    else
      redirect_to clientes_path, alert: "No se puede eliminar el cliente porque tiene autos u órdenes asociadas.", status: :see_other
    end
  end

  private

  def set_customer
    @customer = Customer.includes(:cars).find(params.expect(:id))
  end

  def customer_params
    params.expect(customer: [ :first_name, :last_name, :phone, :document_type, :document_number, :email, :address ])
  end
end
