class Cocktail < ActiveRecord::Base
  mount_uploader :image, CocktailImageUploader
  has_many :ingridients, dependent: :destroy
  has_many :products, through: :ingridients

  has_many :ordered_cocktails
  has_many :orders, through: :ordered_cocktails

  before_save { self.name = name.titleize }

  validates :name, presence: true, allow_blank: false
  validate :validate_ingridients

  scope :search_by_name, -> (name) { where("cocktails.name LIKE ?", "%#{name}%") }

  scope :search_by_ingridients_name, ->(name) {
    eager_load(:products)
        .where("products.name LIKE ?", "%#{name}%")
  }

  def validate_ingridients
    if ingridients.size < 2
      errors.add(:ingridients, 'quantity must be greater than one')
    elsif ingridients.select { |ingridient| ingridient.product.product_type =='drink' }.size<1
      errors.add(:ingridients, 'with product type \'drink\' must be present in cocktail (minimum is 1 product)')
    end
  end

  accepts_nested_attributes_for :ingridients, reject_if: lambda { |attributes| attributes[:value].blank? && attributes[:product_id].blank? }

  def value
    ingridients.inject(0) { |sum, ingridient|
      sum + (ingridient.product.product_type == 'drink' ? ingridient.value : 0)
    }
  end

  def price
    ingridients.inject(0) { |price, ingridient|
      price + (ingridient.value / ingridient.product.min_value) * ingridient.product.price
    }.ceil
  end

  def self.find_with_includes (id)
    self.includes(ingridients: [:product]).find id

  end

  def self.all_with_includes
    self.includes(ingridients: [:product]).all

  end

  def self.all_with_includes_by_product product

    self.joins(:products).includes(ingridients: [:product]).where("products.name=?", product)

  end

  def type
    value < 150 ? 'short' : 'long'
  end


end
