class CreateCards < ActiveRecord::Migration[6.1]
  def change
    create_table :cards do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.integer :qty

      t.timestamps
    end
  end
end
