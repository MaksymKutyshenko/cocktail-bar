class AddTotalEarnedToWorkset < ActiveRecord::Migration
  def change
    add_column :worksets, :total_earned, :float
  end
end
