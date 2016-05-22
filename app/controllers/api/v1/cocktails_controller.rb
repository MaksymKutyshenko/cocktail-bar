class Api::V1::CocktailsController < Api::ApiApplicationController

  def index
    @cocktails = Cocktail.all_with_includes
    render json: @cocktails, :include => {
        :ingridients => {
            :include => {:product => {:except => [:created_at, :updated_at]}},
            :except => [:created_at, :updated_at]
        } },
           :except => [:created_at, :updated_at]
  end
end
