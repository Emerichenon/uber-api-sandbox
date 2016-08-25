class CreateRides < ActiveRecord::Migration[5.0]
  def change
    create_table :rides do |t|
      t.string :departure
      t.string :destination
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
