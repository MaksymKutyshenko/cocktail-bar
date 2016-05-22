class CreateWorksets < ActiveRecord::Migration
  def change
    create_table :worksets do |t|
      t.integer :table_id
      t.integer :waiter_id
      t.integer :status

      t.timestamps null: false
    end
  end
end
