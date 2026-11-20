class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :service

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :subtotal, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_validation :set_unit_price_from_service, on: :create
  before_validation :calculate_subtotal
  after_save :update_order_total
  after_destroy :update_order_total

  private

  def set_unit_price_from_service
    self.unit_price ||= service&.price || 0
  end

  def calculate_subtotal
    self.subtotal = (quantity || 1) * (unit_price || 0)
  end

  def update_order_total
    order.recalculate_total! if order.present?
  end
end
