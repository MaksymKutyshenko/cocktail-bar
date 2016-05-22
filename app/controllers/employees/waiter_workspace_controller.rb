class Employees::WaiterWorkspaceController < Employees::EmployeesApplicationController


  def index
    @waiter = select_waiter(params[:id])
    if @waiter
      @worksets = Workset.select_with_table(params[:id])
      @worksets_count = Workset.orders_count(params[:id])
      @worksets_sum = Workset.active_orders_sum(params[:id])
    end
  end

  def answer_alarm
    update_status(Table, params[:id], Table.statuses[:occupied])
    flash[:success] = 'Now go, check what they want'
    redirect_to_waiter
  end

  def clear_table
    workset = Workset.find_open(params[:id])
    if workset.orders.pending.blank? && workset.orders.waiting_for_payment.blank?
      update_status(Table, params[:id], Table.statuses[:free])
      order_status_shift(params[:id], Order.statuses[:closed])
      payout(workset)
      flash[:success] = 'Table was cleared successfully'
    else
      flash[:warning] = 'Looks like there was new order placed'
    end
    redirect_to_waiter

  end

  def status_update
    order_status_shift(params[:table_id], params[:status])
    redirect_to_waiter
  end

  def redirect_to_waiter
    redirect_to request.referer.blank? ? root_url : request.referer
  end

  private

  def order_status_shift(table_id, status)
    about_to_be_updated =Order.where(table_id: table_id).where(status: required_status(status)) unless status.to_i>4
    about_to_be_updated.update_all(status: status) unless about_to_be_updated.blank?

  end

  def required_status(status)
    status.to_i-1
  end

  def payout(workset)
    unless workset.orders.closed.blank?
      workset.update(total_earned: workset.carrot_on_a_stick)
    end
  end

  def update_status(object, id, status)
    object.update(id, status: status)
  end

  def select_waiter(id)
    Waiter.find_by_id(id)
  end

end
