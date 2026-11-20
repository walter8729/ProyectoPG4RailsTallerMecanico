class Service < ApplicationRecord
  has_many :order_details, dependent: :restrict_with_error
  has_many :orders, through: :order_details

  validates :name, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(:name) }
end
