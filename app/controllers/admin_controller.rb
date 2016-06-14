require 'csv'

class AdminController < ApplicationController

  before_filter :check_privileges!, except: [:index, :refresh_stock_values, :refresh_graph]

  def new
  end

  #Method to process the uploaded CSV
  def process_csv
    begin
      accepted_formats = [".csv"]
      if accepted_formats.include? File.extname(params[:file].original_filename)
        Stock.import(params[:file])
        flash[:notice] = "Data Uploaded Successfully"
      else
        flash[:notice] = "Please upload CSV files only"
      end
    rescue => e
      flash[:notice] = e.message
      redirect_to :action => 'new'
    end
  end

  def new_refresh_time
    begin
      @time = RefreshTime.new
    rescue => e
      flash[:notice] = "Something went Wrong"
    end
  end

  #Method to create stock values refresh time
  def create
    begin
      @get_time = RefreshTime.create!(user_params)
      if @get_time.save
        flash[:notice] = "Successfully Saved"
        redirect_to root_path
      else
        flash[:alert] = "Please try again. Something went Wrong"
        redirect_to root_path
      end
    rescue => e
      flash[:notice] = "Something went Wrong"
    end
  end

  #Method to display all stocks
  def index
    begin
      refresh_time_record = RefreshTime.last
      $refresh_time = 10000
      $refresh_time = refresh_time_record.seconds * 1000 if !refresh_time_record.nil?
      @all_stocks = Stock.all
      session[:recent_values] = Array.new
      session[:count] = 1
    rescue => e
      flash[:notice] = "Something went Wrong"
    end
  end

  def show
  end

  #Method to refresh stock values periodically
  def refresh_stock_values
    begin
      query = "select temp.stk,temp.ticker_symbol,temp.company,temp.stock_value from (SELECT stocks.id as stk,stocks.ticker_symbol,stocks.company,stock_values.stock_value FROM `stocks` INNER JOIN `stock_values` ON `stock_values`.`stock_id` = `stocks`.`id` ORDER BY RAND())as temp group by stk"
      @all_stocks = ActiveRecord::Base.connection.exec_query(query)
      session[:recent_values] << @all_stocks.to_hash
      session[:count] += 1    
      session[:recent_values].shift if session[:count] > 11
        #Ajax Response         
        respond_to do |format|
          format.html 
          format.json { render :json =>  @all_stocks }
        end
    rescue => e
      flash[:notice] = "Something went Wrong"
    end
  end

  #Method to refresh graph periodically
  def refresh_graph
    begin
      stk_selected = params[:stockId].to_i
      recent_values = session[:recent_values].flatten      
      recent = recent_values.map{|v| v['stock_value'] if v['stk'] == stk_selected}      
      @recent = recent.reject { |c| c.nil? }
      #Ajax Response         
      respond_to do |format|
        format.html 
        format.json { render :json =>  @recent }
      end
    rescue => e
      flash[:notice] = "Something went Wrong"
    end
  end

  private

  def user_params
    params.require(:refresh_time).permit(:seconds)
  end

  #Checking admin privileges
  def check_privileges!
    redirect_to "/admin/index", notice: 'You dont have Access to the Requested Page' if !user_signed_in?
  end

end
