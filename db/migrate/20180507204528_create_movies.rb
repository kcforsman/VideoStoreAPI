class CreateMovies < ActiveRecord::Migration[5.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.date :release_date
      t.string :overview
      t.integer :inventory

      t.timestamps
    end
  end
end
