class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :uber_token, :string
    add_column :users, :uber_refresh_token, :string
    add_column :users, :uber_picture, :string
  end
end
