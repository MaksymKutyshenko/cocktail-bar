class AddImageToCocktails < ActiveRecord::Migration
  def change
    add_column :cocktails, :image, :string
    add_column :products, :image, :string
    add_column :cocktails, :description, :text
  end
end
