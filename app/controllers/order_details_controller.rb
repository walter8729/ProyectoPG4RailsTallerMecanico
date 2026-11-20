class OrderDetailsController < ApplicationController
  before_action :set_order

  def create
    @order_detail = @order.order_details.build(order_detail_params)
    service = Service.find_by(id: @order_detail.service_id)

    if service
      @order_detail.unit_price = service.price
      @order_detail.subtotal = (@order_detail.quantity || 1) * service.price

      if @order_detail.save
        @order.recalculate_total!
        redirect_to order_path(@order), notice: "Servicio '#{service.name}' agregado a la orden."
      else
        redirect_to order_path(@order), alert: "No se pudo agregar el servicio: #{@order_detail.errors.full_messages.join(', ')}."
      end
    else
      redirect_to order_path(@order), alert: "Debes seleccionar un servicio válido."
    end
  end

  def destroy
    @order_detail = @order.order_details.find(params.expect(:id))
    nombre_servicio = @order_detail.service.name
    @order_detail.destroy
    @order.recalculate_total!

    redirect_to order_path(@order), notice: "Servicio '#{nombre_servicio}' removido de la orden.", status: :see_other
  end

  private

  def set_order
    @order = Order.find(params.expect(:order_id))
  end

  def order_detail_params
    params.expect(order_detail: [ :service_id, :quantity ])
  end
end
