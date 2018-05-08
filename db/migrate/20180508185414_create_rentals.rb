class CreateRentals < ActiveRecord::Migration[5.1]
  def change
    create_table :rentals do |t|
      t.date :checkout_date
      t.date :due_date
      t.boolean :returned, default: false
      t.references :customer, index: true, foreign_key: true
      t.references :movie, index: true, foreign_key: true

      t.timestamps
    end
  end
end
