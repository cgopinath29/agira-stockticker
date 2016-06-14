require "activerecord-import/base"
ActiveRecord::Import.require_adapter('mysql2')

class Stock < ActiveRecord::Base

	has_many :stock_values	
	validates :company,:initial_stock_value, presence: true
	validates :ticker_symbol, :uniqueness => { message: "has been already Taken"}
	after_create :create_dummy_values

	#Method to read the uploaded csv file
	def self.import(file)
		CSV.foreach(file.path, headers: true) do |row|
			@@val = row.to_hash
			Stock.create! @@val
		end
	end

	#Method to create dummy values and bulk insert
	def create_dummy_values
		stock_rec = @@val
		@stock = Stock.find_by_ticker_symbol(stock_rec["ticker_symbol"])
		@in_val = stock_rec["initial_stock_value"].to_f
		@first_val = (@in_val - 100) <= 0 ? 0 : @in_val-100
		columns = [:stock_value, :stock_id]
		@all_dummy =[]
		(1..20).each do
			stock_value = rand(@first_val..@in_val+100)
			@all_dummy << @stock.stock_values.new({:stock_value => stock_value})
		end
		StockValue.import columns, @all_dummy
	end

end
