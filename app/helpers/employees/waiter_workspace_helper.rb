module Employees::WaiterWorkspaceHelper

  def waiter_dropdown
    collection_select(:waiter, :id, Waiter.assigned, :id, :fullname, prompt: true)
  end

  def order_table_content_group(table, count_order_states, order_sums)
    " <td class='text-center'> #{table.name} </td>
                <td class='text-center'> #{alarm_button(table)} </td>
                <td class='text-center'>#{delivery_button(table.id, count_order_states[[table.id, Order.statuses[:waiting_for_payment]]].to_i)} </td>
                <td class='text-center'> #{payment_button(table.id, count_order_states)} </td>
                <td class='text-center'> #{clear_table_button(table, count_order_states)}</td>
                <td class='text-center'> #{sum_field(waiters_share_sum(order_sums[table.id]))}  </td>".html_safe

  end

  private

  def alarm_button(table)
    if table.waiting?
      "<div class = 'btn btn-warning'> <span class='glyphicon glyphicon-bell gly-spin'> </span>
      #{link_to "alarm", employees_answer_alarm_path(:id => table.id), style: "color:inherit"}
      </div>"
    else
      "<div class = 'btn btn-info'> <span class='glyphicon glyphicon-ok'> </span>
      no need to hurry
      </div>"
    end
  end

  def delivery_button(table_id, orders)
    if orders > 0
      "<div class = 'btn btn-warning'> <span class='glyphicon glyphicon-shopping-cart'> </span> <span class = 'badge'>#{orders} </span>
    #{link_to " not delivered", employees_status_update_path(:table_id => table_id, :status => Order.statuses[:delivered]), style: "color:inherit"}
      </div>"

    else
      "<div class = 'btn btn-success'> <span class='glyphicon glyphicon-ok'> </span>
      delivered
      </div>"
    end
  end

  def payment_button(table_id, orders)
    unpayed_orders = orders[[table_id, Order.statuses[:waiting_for_payment]]].to_i+orders[[table_id, Order.statuses[:delivered]]].to_i
    if unpayed_orders > 0
      "<div class = 'btn btn-warning'> <span class='glyphicon glyphicon-usd'> </span> <span class = 'badge'>#{unpayed_orders} </span>
    #{link_to "unpayed", employees_status_update_path(:table_id => table_id, :status => Order.statuses[:payed]), style: "color:inherit"}
      </div>"
    else
      "<div class = 'btn btn-success'> <span class='glyphicon glyphicon-ok'> </span>
      payed
      </div>"
    end
  end

  def clear_table_button(table, grouped_orders_count)
    if table.free?
      "<div class = 'btn btn-info'> <span class='glyphicon glyphicon-ok'> </span>
      table vacant
      </div>"
    else
      if grouped_orders_count[[table.id, Order.statuses[:pending]]].blank? && grouped_orders_count[[table.id, Order.statuses[:waiting_for_payment]]].blank? && grouped_orders_count[[table.id, Order.statuses[:delivered]]].blank? && table.occupied?
        "<div class = 'btn btn-success'> <span class='glyphicon glyphicon-thumbs-up'> </span>
      #{link_to "clear table", employees_clear_table_path(:id => table.id), style: "color:inherit"}
        </div>"
      else
        "<div class = 'btn btn-danger', style: 'color:inherit'> <span class='glyphicon glyphicon-hourglass'> </span>
      table busy
      </div>"
      end
    end
  end

  def sum_field(waiters_sum)
    "#{waiters_sum}<span class='glyphicon glyphicon-usd'> </span>"
  end

  def waiters_share_sum(orders_sum)
    orders_sum.to_f*@waiter.waiters_share
  end
end
