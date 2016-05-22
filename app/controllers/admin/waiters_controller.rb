class Admin::WaitersController < Admin::SignedApplicationController

  before_action :signed_in_user, only: [:show, :edit, :update, :index, :destroy]

  before_filter :find_item, only: [:edit, :update, :destroy, :show, :update_tables]

  def index
    @waiters = Waiter.hired
    @tables = Workset.open.to_a.group_by { |item| item[:waiter_id] }
  end

  def new
    @waiter = Waiter.new
  end

  def create
    @waiter = Waiter.create item_params
    redirect_to action: 'index'
  end

  def show
    @tables_status = waiter_tables_status(@waiter.id.to_i)
    @tables = Table.free
  end

  def edit

  end

  def destroy
    worksets = Workset.where(waiter_id: @waiter.id, status: 0)

    unless worksets.empty?
        @waiter.errors.add(:tables, 'must be released before firing waiter')
    end

    if @waiter.errors.empty?
        @waiter.update_attribute :status, :fired
      flash[:success] = "Waiter #{@waiter.firstname.humanize} #{@waiter.lastname.humanize} was fired"
    else
      flash[:warning] = @waiter.errors.full_messages.to_sentence
    end
    redirect_to action: 'index'
  end

  def update
    @waiter.update_attributes item_params
    if @waiter.errors.empty?
      flash[:success] = "Waiter #{@waiter.firstname.humanize} #{@waiter.lastname.humanize} was updated successfully"
      redirect_to action: :index
    else
      flash[:warning] = @waiter.errors.full_messages.to_sentence
      render :edit
    end
  end

  def update_tables
    tables = params[:tables]
    worksets = Workset.where(waiter_id: @waiter.id, status: 0).to_a

    unless tables.nil?
      tables.each do |table|
        set = worksets.find_index { |h| h.table_id == table[0].to_i }
        if set.nil?
          create_workset(table[0], @waiter.id)
        else
          worksets.delete_at(set)
        end
      end
    end

    worksets.each do |workset|
      close_workset workset.id
    end

    flash[:success] = "Waiter #{@waiter.firstname.humanize} #{@waiter.lastname.humanize} tables was updated successfully"
    redirect_to action: :index
  end

  def create_workset (table, waiter)
    Workset.create(table_id: table, waiter_id: waiter, status: 0)
  end

  def close_workset (id)
    Workset.find(id).update_attributes(status: 1)
  end

  def waiter_tables_status waiter_id

    worksets = Workset.open.to_a
    @result = {}

    worksets.each do |item|
      if item[:waiter_id] != waiter_id
        @result[item[:table_id]] = 'busy'
      elsif item[:waiter_id] == waiter_id
        @result[item[:table_id]] = 'fixed'
      end
    end

    @result

  end

  def item_params
    params.require(:waiter).permit(:id, :firstname, :lastname, :photo, :remove_photo, :status)
  end

  private
  def find_item
    @waiter = Waiter.find params[:id]
  end

end
