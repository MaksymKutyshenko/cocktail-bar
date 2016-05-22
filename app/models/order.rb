class Order < ActiveRecord::Base

  include WelcomeHelper

  has_many :ordered_cocktails
  has_many :cocktails, through: :ordered_cocktails
  belongs_to :table

  scope :uncleared, -> {where("status IN (#{Table.statuses[:free]},#{Table.statuses[:waiting]}) ")}

  enum status: [ :pending, :waiting_for_payment, :delivered, :payed, :closed]


  def self.add_cocktail_to_order cocktail_id, current_table

    order = Order.find_or_create_by(:status => Order.statuses[:pending], :table_id => current_table)
    OrderedCocktail.create(order_id: order.id, cocktail_id: cocktail_id)


  end

  def self.sum_to_pay current_table
    sum = 0

    cocktails =
        Cocktail
            .joins(:orders)
            .includes(ordered_cocktails: [:order])
            .where("`orders`.status = ? AND `orders`.table_id = ?", Order.statuses[:pending], current_table)
            .all_with_includes

    cocktails.each do |cocktail|
      sum += cocktail.price
    end

    sum

  end


end
