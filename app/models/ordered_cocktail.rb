class OrderedCocktail < ActiveRecord::Base
  belongs_to :order
  belongs_to :cocktail

end
