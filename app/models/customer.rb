class Customer < ApplicationRecord
  DOCUMENT_TYPES = %w[CI RUC Extranjero].freeze

  has_many :cars, dependent: :destroy

  validates :first_name, :last_name, :phone, presence: true
  validates :document_type, presence: true, inclusion: { in: DOCUMENT_TYPES }
  validates :document_number, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  scope :ordered, -> { order(Arel.sql("LOWER(last_name)"), Arel.sql("LOWER(first_name)")) }

  def full_name
    [ first_name, last_name ].compact_blank.join(" ")
  end
end
