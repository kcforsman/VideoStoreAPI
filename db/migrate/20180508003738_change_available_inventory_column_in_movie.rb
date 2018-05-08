class ChangeAvailableInventoryColumnInMovie < ActiveRecord::Migration[5.1]
  def change
    change_column :movies, :available_inventory, :integer, default: 0
  end
end
