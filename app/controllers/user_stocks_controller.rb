class UserStocksController < ApplicationController
  
  def create
    stock = Stock.find_by_ticker(params[:stock_ticker])
    StockQuote::Stock.new(api_key: 'pk_e8793f14b4b3494c97abf63680b8ba21')
    var = StockQuote::Stock.quote(params[:stock_ticker])

    stock_new = Stock.new(ticker: var.symbol, name: var.company_name, last_price: var.close)
    if stock.blank?
      stock_new.save
    end

    if UserStock.where(user: current_user, stock: stock_new).exists?
      UserStock.update(user: current_user, stock: stock_new)
      flash[:success] = "Stock #{stock_new.name} was successfully updated"
    else
      @user_stock = UserStock.create(user: current_user, stock: stock_new)
      flash[:success] = "Stock #{@user_stock.stock.name} was successfully added"
    end
    redirect_to my_portfolio_path
  end
  
  def destroy
    stock = Stock.find(params[:id])
    @user_stock = UserStock.where(user_id: current_user.id, stock_id: stock.id).first
    @user_stock.destroy
    flash[:notice] = "Stock was successfully removed from portfolio"
    redirect_to my_portfolio_path
  end
end
