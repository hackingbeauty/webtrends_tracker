class KeyValuePairsController < ApplicationController
  skip_before_filter :show_products
  
  def create
    @kvp = KeyValuePair.new(params[:key_value_pair])
    if @kvp.save
      render :text => @kvp.id, :status => 200
    else
      render :text => "failed", :status => 422
    end
  end
  
  def destroy
    @kvp = KeyValuePair.find_by_id(params[:id]).destroy
    render :text => "ok", :status => 200
  end
  
  def autocomplete
    case params[:element_id]
    when "key"
      key_names = KeyValuePair.all(:select => "distinct key", :conditions => ["key LIKE ?", "%#{params[:q]}%"], :limit => 5).map(&:key)
      render :text => key_names.join("\n")
    when "value"
      value_names = KeyValuePair.all(:select => "distinct value", :conditions => ["value LIKE ?", "%#{params[:q]}%"], :limit => 5).map(&:value)
      render :text => value_names.join("\n")
    else
      render :text => "No autocomplete for this element", :status => 422
    end
  end
  
end