class AddColumnToMovie < ActiveRecord::Migration[5.1]
  def change
    add_column :movies, :available_inventory, :integer, default: :inventory
  end
end
