class CreateWaiters < ActiveRecord::Migration
  def change
    create_table :waiters do |t|
      t.string :firstname
      t.string :lastname
      t.string :photo
      t.integer :status

      t.timestamps null: false
    end
  end
end
