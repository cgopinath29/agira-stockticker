class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :ticker_symbol
      t.string :company
      t.decimal :initial_stock_value, precision: 16, scale: 2

      t.timestamps null: false
    end
  end
end
