class Car < ApplicationRecord
  belongs_to :customer
  has_many :orders, dependent: :restrict_with_error

  validates :brand, :model, :year, :plate, :chassis, :mileage, presence: true
  validates :plate, uniqueness: { case_sensitive: false }
  validates :chassis, uniqueness: { case_sensitive: false }
  validates :year, numericality: { only_integer: true, greater_than: 1900, less_than_or_equal_to: ->(_) { Time.current.year + 1 } }
  validates :mileage, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(:brand, :model) }

  def car_label
    "#{brand} #{model} (#{plate})"
  end
end
