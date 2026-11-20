class Customer < ApplicationRecord
  has_many :cars, dependent: :destroy

  scope :ordered, -> { order(Arel.sql("LOWER(last_name)"), Arel.sql("LOWER(first_name)")) }

  def full_name
    [ first_name, last_name ].compact_blank.join(" ")
  end
end
