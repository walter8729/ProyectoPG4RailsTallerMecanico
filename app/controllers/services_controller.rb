class ServicesController < ApplicationController
  before_action :set_service, only: %i[edit update destroy]

  def index
    services = Service.ordered

    if params[:q].present?
      criterio = "%#{params[:q]}%".downcase
      services = services.where("lower(name) LIKE :q OR lower(description) LIKE :q", q: criterio)
    end

    @pagy, @services = pagy(:offset, services)
  end

  def new
    @service = Service.new
  end

  def edit
  end

  def create
    @service = Service.new(service_params)

    if @service.save
      redirect_to services_path, notice: "Servicio registrado correctamente."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @service.update(service_params)
      redirect_to services_path, notice: "Servicio actualizado correctamente."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @service.destroy
      redirect_to services_path, notice: "Servicio eliminado correctamente.", status: :see_other
    else
      redirect_to services_path, alert: "No se puede eliminar el servicio porque tiene órdenes asociadas.", status: :see_other
    end
  end

  private

  def set_service
    @service = Service.find(params.expect(:id))
  end

  def service_params
    params.expect(service: [ :name, :description, :price ])
  end
end
