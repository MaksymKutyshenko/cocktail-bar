class OrderedCocktailsController < ApplicationController

  before_filter :find_item, only: [:destroy]

  def destroy
    @ordered_cocktail.destroy
    redirect_to cart_path

  end

  private
  def find_item
    @ordered_cocktail= OrderedCocktail.find params[:id]
  end

end
