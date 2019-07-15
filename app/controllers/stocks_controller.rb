class StocksController < ApplicationController
  
  def search
    if params[:stock].blank?
      flash.now[:danger] = "You have entered an empty search string"
    else
       begin
        StockQuote::Stock.new(api_key: 'pk_e8793f14b4b3494c97abf63680b8ba21')
        var = StockQuote::Stock.quote(params[:stock])
        @stock = Stock.new(ticker: var.symbol, name: var.company_name, last_price: var.close)
       rescue Exception => e
        return nil
    end
      flash.now[:danger] = "You have entered an incorrect symbol" unless @stock
    end
    respond_to do |format|
      format.js { render partial: 'users/result' }
    end
  end
end