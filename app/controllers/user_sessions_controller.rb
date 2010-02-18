class UserSessionsController < ApplicationController

  skip_before_filter :require_user, :except => [:destroy]

  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      # flash[:notice] = "Login successful!"
      redirect_back_or_default products_path
      return
    end
    flash.now[:error] = "You entered the wrong username and/or password!"
    render :action => :new
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_path
  end

  private
  
end
