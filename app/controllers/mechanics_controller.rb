class MechanicsController < ApplicationController
  before_action :set_mechanic, only: %i[edit update destroy]

  def index
    mechanics = Mechanic.ordered

    if params[:q].present?
      criterio = "%#{params[:q]}%".downcase
      mechanics = mechanics.where(
        "lower(first_name) LIKE :q OR lower(last_name) LIKE :q OR lower(specialty) LIKE :q OR lower(phone) LIKE :q",
        q: criterio
      )
    end

    @pagy, @mechanics = pagy(:offset, mechanics)
  end

  def new
    @mechanic = Mechanic.new
  end

  def edit
  end

  def create
    @mechanic = Mechanic.new(mechanic_params)

    if @mechanic.save
      redirect_to mechanics_path, notice: "Mecánico registrado correctamente."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @mechanic.update(mechanic_params)
      redirect_to mechanics_path, notice: "Mecánico actualizado correctamente."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @mechanic.destroy
      redirect_to mechanics_path, notice: "Mecánico eliminado correctamente.", status: :see_other
    else
      redirect_to mechanics_path, alert: "No se puede eliminar el mecánico porque tiene órdenes asignadas.", status: :see_other
    end
  end

  private

  def set_mechanic
    @mechanic = Mechanic.find(params.expect(:id))
  end

  def mechanic_params
    params.expect(mechanic: [ :first_name, :last_name, :specialty, :phone ])
  end
end
