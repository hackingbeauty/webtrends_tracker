class KeyValuePairsController < ApplicationController
  skip_before_filter :show_products
  
  def create
    @kvp = KeyValuePair.new(params[:key_value_pair])
    if @kvp.save
      render :text => "saved", :status => 200
    else
      render :text => "failed", :status => 422
    end
  end
  
  def destroy
    @kvp = KeyValuePair.find_by_id(params[:id]).destroy
    render :text => "ok", :status => 200
  end
  
end