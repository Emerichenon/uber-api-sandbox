class AddColumsToRides < ActiveRecord::Migration[5.0]
  def change
    add_column :rides, :start_latitude, :float
    add_column :rides, :start_longitude, :float
    add_column :rides, :end_latitude, :float
    add_column :rides, :end_longitude, :float
  end
end
