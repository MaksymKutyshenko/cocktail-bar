class Admin::CocktailsController < Admin::SignedApplicationController
  layout 'application_admin'

  before_filter :find_item, only: [:edit, :update, :destroy, :show]

  before_action :verify_params!, :before_new, only: [:new]

  INGRIDIENt_MAX_COUNT =5

  def index
    @cocktails = Cocktail.all_with_includes
    @items_count = @cocktails.size
    @per_page = PAGINATION_PER_PAGE

    if params[:name].present?
      if 'price' == params[:name]
        @cocktails = @cocktails.sort_by{ |a| a.price } if 'asc' == params[:direction]
        @cocktails = @cocktails.sort_by{ |a| -a.price } if 'desc' == params[:direction]
      else
        @cocktails = @cocktails.order("#{params[:name]} #{params[:direction]}")
      end
    end
    @cocktails = paginate(@cocktails, params[:page], @per_page)
  end

  def new
    prepare_ingridient_items
  end

  def items_params
    params.require(:cocktail).permit(:id, :name, :image, :remove_image, :description, ingridients_attributes: [:id, :value, :product_id, :cocktail_id])
  end

  def create
    @cocktail = Cocktail.create items_params
    if @cocktail.errors.empty?
      flash[:success] = "Cocktail \'#{@cocktail.name.humanize}\' was created successfully"
      redirect_to action: :index
    else
      flash[:warning] = @cocktail.errors.full_messages.to_sentence
      prepare_ingridient_items
      render :new
    end
  end

  def update
    @cocktail.update_attributes items_params
    if @cocktail.errors.empty?
      flash[:success] = "Cocktail \'#{@cocktail.name.humanize}\' was updated successfully"
      redirect_to action: :index
    else
      flash[:warning] = @cocktail.errors.full_messages.to_sentence
      prepare_ingridient_items
      render :edit
    end
  end


  def edit
    prepare_ingridient_items
  end

  def show

  end

  def destroy
    @cocktail.destroy
    if @cocktail.errors.empty?
      flash[:success] = "Cocktail '#{@cocktail.name}' was removed successfully"
      redirect_to action: :index
    else
      flash[:warning] = @cocktail.errors.full_messages.to_sentence
      render action: :index
    end
  end

  private
  def find_item
    @cocktail= Cocktail.find_with_includes params[:id]
  end

  def redirect_to_back error_message
    if error_message.present?
      flash[:warning] = error_message
    end
    redirect_to request.referer.blank? ? root_url : request.referer
  end

  def prepare_ingridient_items
    (INGRIDIENt_MAX_COUNT - @cocktail.ingridients.size).times {
      @cocktail.ingridients.build
    }
  end

  def verify_params!
    @product_id = params[:product]
    unless @product_id.blank?
      if Product.find_by(id: @product_id).blank?
        redirect_to_back "Can not find product with id #{@product_id}"
      end
    end
  end

  def before_new
    @cocktail = Cocktail.new
    product_id = params[:product]

    if validate_product_id? product_id
      @cocktail.ingridients.build(product_id: product_id)
    else
      redirect_to_back "Can not find product with id #{@product_id}"
    end
  end

  def validate_product_id? id
    result = true
    unless id.blank?
      product = Product.find_by(id: id)
      if product.blank?
        result false
      end
    end
    result
  end

end
