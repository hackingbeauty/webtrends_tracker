class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
    
  before_filter :show_products
  
  protected
  
  def show_products
    @products = Product.find(:all)
  end
  
end
