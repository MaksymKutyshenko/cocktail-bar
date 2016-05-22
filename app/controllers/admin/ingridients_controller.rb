class Admin::IngridientsController < Admin::SignedApplicationController
  before_filter :find_item, only: [:edit, :update, :destroy]

  def new
    @ingridient = Ingridient.new
    cocktail= Cocktail.find_by(id: params[:cocktail_id])
    if cocktail.blank?
      flash[:warning]="Can not find cocktail with #{params[:cocktail_id]}"
      redirect_to request.referer.blank? ? root_url : request.referer
    else
      @ingridient.cocktail = cocktail
      session[:redirect_to] ||= request.referer
    end
   end

  def create
    @ingridient = Ingridient.create item_params
    redirect_to session.delete(:redirect_to)
  end

  def item_params
    params.require(:ingridient).permit(:id, :product_id, :cocktail_id, :value)
  end

  def edit
    session[:return_to] ||= request.referer
  end

  def update
    @ingridient.update_attributes item_params
    if @ingridient.errors.empty?
      redirect_to action: 'new'
    else
      render 'edit'
    end
  end

  def destroy
    @ingridient.destroy
    redirect_to action: 'new'
  end


  private
  def find_item
    @ingridient= Ingridient.find params[:id]
  end


end
