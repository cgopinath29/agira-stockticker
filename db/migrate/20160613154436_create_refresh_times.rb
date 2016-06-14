class CreateRefreshTimes < ActiveRecord::Migration
  def change
    create_table :refresh_times do |t|
      t.integer :seconds

      t.timestamps null: false
    end
  end
end
