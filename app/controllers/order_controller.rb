class OrderController < ApplicationController

  before_filter :find_item, only: [:update]

  def create

  end

  def new

  end

  def update

  end

  private
  def find_item
    @order= Order.find_with_includes params[:table_id], params[:status]
  end

end
