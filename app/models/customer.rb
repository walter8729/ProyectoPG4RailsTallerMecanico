class Customer < ApplicationRecord
  # Tipos de documentos permitidos en el sistema
  DOCUMENT_TYPES = %w[CI RUC Extranjero].freeze

  # Expresiones regulares (Regex) para validación de formato:
  # - CI: solo números de 5 a 8 dígitos (ej. 4567890 o 7030890)
  CI_REGEX = /\A[0-9]{5,8}\z/
  # - RUC: números seguidos de guión y un dígito verificador (ej. 4567890-1 o 80012345-6)
  RUC_REGEX = /\A[0-9]+-[0-9]\z/
  # - Extranjero: alfanumérico con guión opcional (ej. AB123456, 12345678-K, DNI)
  EXTRANJERO_REGEX = /\A[A-Z0-9]+(-[A-Z0-9]+)?\z/i

  has_many :cars, dependent: :restrict_with_error

  # Callback: normaliza el número de documento antes de validar
  # Quita puntos separadores de miles (ej. 7.030.890 -> 7030890) y espacios
  before_validation :normalize_document_number

  validates :first_name, :last_name, :phone, presence: true
  validates :document_type, presence: true, inclusion: { in: DOCUMENT_TYPES }
  validates :document_number, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  # Validación personalizada de formato según el tipo de documento seleccionado
  validate :validate_document_format

  scope :ordered, -> { order(Arel.sql("LOWER(last_name)"), Arel.sql("LOWER(first_name)")) }

  def full_name
    [ first_name, last_name ].compact_blank.join(" ")
  end

  private

  # Normaliza el documento: remueve puntos de miles y espacios en blanco
  def normalize_document_number
    return if document_number.blank?

    self.document_number = document_number.to_s.strip.delete(".")
  end

  # Valida el formato del documento según su tipo:
  # - CI: Exige números limpios de 5 a 8 dígitos
  # - RUC: Exige formato de números con guión y dígito verificador (ej. 1234567-8)
  # - Extranjero: Acepta alfanumérico para pasaportes o cédulas extranjeras
  def validate_document_format
    return if document_number.blank? || document_type.blank?

    case document_type
    when "CI"
      unless document_number.match?(CI_REGEX)
        errors.add(:document_number, "para Cédula debe contener entre 5 y 8 números sin guión ni letras (los puntos se quitan automáticamente)")
      end
    when "RUC"
      unless document_number.match?(RUC_REGEX)
        errors.add(:document_number, "para RUC debe tener el formato números con guión y dígito verificador (ej: 80012345-6)")
      end
    when "Extranjero"
      unless document_number.match?(EXTRANJERO_REGEX)
        errors.add(:document_number, "para documento extranjero solo debe contener letras, números y opcionalmente un guión")
      end
    end
  end
end
