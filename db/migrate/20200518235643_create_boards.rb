class CreateBoards < ActiveRecord::Migration[5.2]
  def change
    create_table :boards do |t|
      t.string :lists
      t.string :name
      t.integer :owner
      t.timestamps
    end
  end
end