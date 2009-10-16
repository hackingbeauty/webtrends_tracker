class KeyValuePairsController < ApplicationController

  skip_before_filter :show_products
  
  before_filter :load_key_value_pair
  
  def create
    @key_value_pair = KeyValuePair.new(params[:key_value_pair])
    if @key_value_pair.save
      flash[:notice] = "Key Value Pair created successfully"
      render :update do |page|
        page.redirect_to @key_value_pair.tag
      end
    else
      render :update do |page|
        page["kvp_form"].replace_html :partial => "key_value_pairs/form", :locals => { :key_value_pair => @key_value_pair }
      end
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