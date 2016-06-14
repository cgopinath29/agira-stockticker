class CreateStockValues < ActiveRecord::Migration
  def change
    create_table :stock_values do |t|
      t.decimal :stock_value, precision: 16, scale: 2
      t.references :stock, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
