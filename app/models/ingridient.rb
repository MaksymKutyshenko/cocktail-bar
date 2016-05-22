class Ingridient < ActiveRecord::Base

  belongs_to :cocktail
  belongs_to :product

  #validates :value, numericality: {greater_than: 0}
  validates :product_id, presence: true, allow_blank: false

  validate :validate_value

  def validate_value
    unless product.blank?
      errors.add(:value, "for product '#{product.name}' must_be greater than #{product.min_value} ") if product.min_value > value
    end
  end

  def price
    (value / product.min_value) * product.price
  end

end
