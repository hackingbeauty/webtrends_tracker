class SpreadsheetsController < ApplicationController
  
  include SpreadsheetsHelper
  
  def index
    response.headers['Content-Type'] = 'text/csv'
    response.headers['Content-Disposition'] = "attachment; filename=summary-from-#{Date.today}.csv"
    @products = Product.all(:include => { :tags => :key_value_pairs })
    render :text => create_csv(@products)
  end
  
end