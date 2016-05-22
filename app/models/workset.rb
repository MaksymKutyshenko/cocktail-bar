class Workset < ActiveRecord::Base
  belongs_to :table
  belongs_to :waiter
  has_many :orders, through: :table

  enum status: [ :open, :closed]

  @@waiters_share = 0.05

  def carrot_on_a_stick
    table.orders.closed.sum(:sum)*@@waiters_share
  end

  def self.select_with_table(id)
    self.includes(:table).where(waiter_id: id).open
    # Workset.joins(:orders).includes(table:[:orders]).where(waiter_id: id).open.distinct
  end

  def self.active_orders_sum(id)
    self.joins(:table,:orders)
        .where(waiter_id: id)
        .open
        .where("orders.status IN (#{Order.statuses[:waiting_for_payment]},#{Order.statuses[:delivered]},#{Order.statuses[:payed]}) ")
        .group('worksets.table_id'
        ).sum(:sum)
  end

  def self.orders_count(id)
    self.joins(:table,:orders).where(waiter_id: id).open.group('worksets.table_id','orders.status').count
  end

  def self.find_open(table_id)
    self.find_by(table_id: table_id,status: 'open')
  end

end
