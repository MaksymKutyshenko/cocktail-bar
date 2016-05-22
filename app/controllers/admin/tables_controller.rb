class Admin::TablesController < Admin::SignedApplicationController
  before_action :find_item, only: [:edit, :update, :destroy]

  def index
    @tables = Table.all
  end

  def new
    @table = Table.new
  end

  def create
    if table_name_exists? params[:table][:name]
      @table = Table.new
      flash[:warning] = "Table name \"#{params[:table][:name]}\" already exists. Please choose another name."
      render :new
    else
      @table = Table.create item_params
      if @table.errors.empty?
        flash[:success] = "Table \'#{@table.name.humanize}\' added successfully'"
        redirect_to action: :index
      else
        flash[:warning] = @table.errors.full_messages.to_sentence
        render :new
      end
    end
  end

  def update
    if table_name_exists? params[:table][:name]
      @table = Table.find(params[:id])
      flash[:warning] = "Table name \"#{params[:table][:name]}\" already exists. Please choose another name."
      render :edit
    else
      @table.update_attributes item_params
      if @table.errors.empty?
        redirect_to action: :index
      else
        flash[:warning] = @table.errors.full_messages.to_sentence
        render :edit
      end
    end
  end

  def destroy
    @table.destroy
    if @table.errors.empty?
      flash[:success] = "Cocktail \"#{@table.name}\" was removed successfully"
      redirect_to action: :index
    else
      flash[:warning] = @table.errors.full_messages.to_sentence
      redirect_to action: :index
    end
  end

  def item_params
    params.require(:table).permit(:id, :name, :status)
  end

  private
  def find_item
    @table = Table.find params[:id]
  end

  def table_name_exists?(name)
    return Table.find_by(name: name) != nil
  end
end
