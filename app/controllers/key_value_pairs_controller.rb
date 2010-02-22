class KeyValuePairsController < ApplicationController

  skip_before_filter :show_products
  
  before_filter :load_key_value_pair, :except => [:create]
  
  def create
    @key_value_pair = KeyValuePair.new(params[:key_value_pair])
    respond_to do |type|
      if @key_value_pair.save      
        type.html do 
          flash[:notice] = "Key Value Pair created successfully"
          redirect_to @key_value_pair.tag
        end
        type.js {render :json => @key_value_pair }
      else
        type.html do 
          flash[:error] = "Could not create Key Value Pair"
          redirect_to @key_value_pair.tag
        end
        type.js { render :json => @key_value_pair.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @key_value_pair.destroy
    redirect_to @key_value_pair.tag
  end

  private
  
  def load_key_value_pair
    @key_value_pair = KeyValuePair.find(params[:id]) if params[:id]
  end
  
  
end
