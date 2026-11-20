class Mechanic < ApplicationRecord
  has_many :assignments, dependent: :restrict_with_error
  has_many :orders, through: :assignments

  validates :first_name, :last_name, :specialty, :phone, presence: true

  scope :ordered, -> { order(:last_name, :first_name) }

  def full_name
    "#{first_name} #{last_name}"
  end
end
