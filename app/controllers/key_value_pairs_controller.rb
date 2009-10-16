class KeyValuePairsController < ApplicationController

  skip_before_filter :show_products
  before_filter :load_key_value_pair
  
  def new
    @key_value_pair = KeyValuePair.new
    respond_to do |wants|
      wants.js do
        render :partial => "form"
      end
    end
  end
  
  def create
    @key_value_pair = KeyValuePair.new(params[:key_value_pair])
    if @key_value_pair.save
      render :text => @key_value_pair.id, :status => 200
    else
      render :text => "failed", :status => 422
    end
  end
  
  def destroy
    @key_value_pair.destroy
    render :text => "ok", :status => 200
  end

  private
  
  def load_key_value_pair
    @key_value_pair = KeyValuePair.find(params[:id]) if params[:id]
  end
  
  
end