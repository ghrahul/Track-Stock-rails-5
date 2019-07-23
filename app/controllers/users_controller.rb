class UsersController < ApplicationController
  before_action :portfolio_update, only: [:my_portfolio]
  
  def my_portfolio
    @user_stocks = current_user.stocks
    @user
  end
  
  def my_friends
    @friendships = current_user.friends
  end
  
  def search
    if params[:search_param].blank?
      flash.now[:danger] = "You have entered an empty search string"
    else
      @users = User.search(params[:search_param])
      @users = current_user.except_current_user(@users)
      flash.now[:danger] = "No users match this search criteria" if @users.blank?
    end
    respond_to do |format|
      format.js { render partial: 'friends/result' }
    end
  end
  
  def add_friend
    @friend = User.find(params[:friend])
    current_user.friendships.build(friend_id: @friend.id)
    if current_user.save
      flash[:notice] = "Friend was successfully added"
    else
      flash[:danger] = "There was something wrong with the friend request"
    end  
    redirect_to my_friends_path
  end
  
  def show
    @user = User.find(params[:id])
    @user_stocks = @user.stocks
  end

  def portfolio_update
    @user = current_user
    @user.stocks.each do |stock|
       stock.update(last_price: StockQuote::Stock.quote(stock.ticker).latest_price)
    end
  end
  
end