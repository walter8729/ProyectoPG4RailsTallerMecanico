class OrdersController < ApplicationController
  before_action :set_order, only: %i[show edit update destroy update_status]
  before_action :load_form_collections, only: %i[new create edit update]

  def index
    orders = Order.includes(:car, :customer, :services, :mechanics).ordered

    if params[:status].present?
      orders = orders.where(status: params[:status])
    end

    if params[:q].present?
      criterio = "%#{params[:q]}%".downcase
      orders = orders.joins(:car, :customer).where(
        "lower(cars.plate) LIKE :q OR lower(cars.chassis) LIKE :q OR lower(customers.first_name) LIKE :q OR lower(customers.last_name) LIKE :q OR lower(orders.notes) LIKE :q",
        q: criterio
      )
    end

    @pagy, @orders = pagy(:offset, orders)
  end

  def show
  end

  def new
    @order = Order.new(order_date: Date.current, status: "Pendiente")
  end

  def edit
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      sync_associations
      @order.recalculate_total!
      redirect_to order_path(@order), notice: "Orden de trabajo creada correctamente."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @order.update(order_params)
      sync_associations
      @order.recalculate_total!
      redirect_to order_path(@order), notice: "Orden de trabajo actualizada correctamente."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def update_status
    if params[:status].present? && Order::STATUSES.include?(params[:status])
      @order.update(status: params[:status])
      if params[:status] == "Completada" && @order.delivery_date.blank?
        @order.update(delivery_date: Date.current)
      end
      redirect_to order_path(@order), notice: "Estado actualizado a #{@order.status}."
    else
      redirect_to order_path(@order), alert: "Estado no válido."
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_path, notice: "Orden de trabajo eliminada.", status: :see_other
  end

  private

  def set_order
    @order = Order.find(params.expect(:id))
  end

  def load_form_collections
    @cars = Car.includes(:customer).ordered
    @services = Service.ordered
    @mechanics = Mechanic.ordered
  end

  def order_params
    params.expect(order: [ :car_id, :order_date, :delivery_date, :status, :notes ])
  end

  def sync_associations
    # Sincronizar mecánicos asignados
    if params[:mechanic_ids].present?
      selected_ids = params[:mechanic_ids].reject(&:blank?).map(&:to_i)
      @order.assignment_ids = []
      selected_ids.each do |m_id|
        @order.assignments.find_or_create_by(mechanic_id: m_id, assigned_at: @order.order_date || Date.current)
      end
    elsif params.key?(:mechanic_ids)
      @order.assignments.destroy_all
    end

    # Sincronizar servicios (detalles)
    if params[:order_services].present?
      @order.order_details.destroy_all
      params[:order_services].each do |_idx, item|
        service_id = item[:service_id]
        quantity = item[:quantity].to_i
        next if service_id.blank? || quantity <= 0

        service = Service.find_by(id: service_id)
        next unless service

        unit_price = item[:unit_price].present? ? item[:unit_price].to_i : service.price
        subtotal = quantity * unit_price

        @order.order_details.create!(
          service_id: service.id,
          quantity: quantity,
          unit_price: unit_price,
          subtotal: subtotal
        )
      end
    end
  end
end
