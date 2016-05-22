class CartController < ApplicationController

  include WelcomeHelper

  before_action :get_current_table, :get_table_name, only: [:show, :checkout]

  def show
    @cocktails = {}

    @cocktails['not payed'] =
      Cocktail
         .joins(:orders)
         .includes(ordered_cocktails: [:order])
         .where("`orders`.status = ? AND `orders`.table_id = ?", Order.statuses[:pending], @current_table).all_with_includes


    @cocktails[:payed] =
      Cocktail
        .joins(:orders)
        .includes(ordered_cocktails: [:order])
        .where("`orders`.status in(#{Order.statuses[:payed]}, #{Order.statuses[:delivered]}, #{Order.statuses[:waiting_for_payment]}) AND `orders`.table_id = ?",  @current_table)
        .all_with_includes

    @cocktails

  end

  def checkout
    Order
        .where(:table_id => @current_table, :status => Order.statuses[:pending])
        .update_all(:status => Order.statuses[:waiting_for_payment], :sum => Order.sum_to_pay(@current_table) )

    redirect_to action: 'show'
  end

  private
  def get_current_table
    @current_table = get_current_table_id
  end

  def get_table_name
    @table_name = Table.find(@current_table).name
  end

end
