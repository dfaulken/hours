class CreateShifts < ActiveRecord::Migration[5.1]
  def change
    create_table :shifts do |t|
      t.datetime :start
      t.float :length, default: 1.0
      t.boolean :mbta, default: false

      t.timestamps
    end
  end
end
