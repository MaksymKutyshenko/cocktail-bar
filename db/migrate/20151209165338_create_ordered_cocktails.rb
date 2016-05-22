class CreateOrderedCocktails < ActiveRecord::Migration
  def change
    create_table :ordered_cocktails do |t|
      t.integer :cocktail_id
      t.integer :order_id

      t.timestamps null: false
    end
  end
end
