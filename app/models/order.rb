class Order < ApplicationRecord
  STATUSES = %w[Pendiente En\ Proceso Completada].freeze

  belongs_to :car
  has_one :customer, through: :car

  has_many :order_details, dependent: :destroy
  has_many :services, through: :order_details

  has_many :assignments, dependent: :destroy
  has_many :mechanics, through: :assignments

  accepts_nested_attributes_for :order_details, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :assignments, allow_destroy: true, reject_if: :all_blank

  validates :order_date, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :total, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(order_date: :desc, id: :desc) }

  def recalculate_total!
    self.total = order_details.sum { |detail| detail.subtotal || 0 }
    save(validate: false) if persisted?
  end
end
