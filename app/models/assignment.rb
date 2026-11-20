class Assignment < ApplicationRecord
  belongs_to :order
  belongs_to :mechanic

  validates :assigned_at, presence: true
  validates :mechanic_id, uniqueness: { scope: :order_id, message: "ya está asignado a esta orden" }
end
