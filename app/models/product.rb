class Product < ActiveRecord::Base
  mount_uploader :image, ProductImageUploader
  has_many :ingridients
  has_many :cocktails, through: :ingridients, dependent: :destroy

  before_save {self.name = name.titleize}

  validates :cost_price, :min_value, :product_type, presence: true
  validates :name, presence: true, allow_blank: false
  validates :cost_price, :min_value, numericality: {greater_than: 0}

  @@product_types =['drink','not drink']

  @@tax = 0.04
  @@markup_percent =0.5

  def price
    cost_price + markup + (markup * @@tax)
  end

  def markup
    cost_price*@@markup_percent

  end

  def self.product_types
    @@product_types
  end

  def tname
    self.name+'--'+self.product_type
  end

end
