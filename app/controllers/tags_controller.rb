class TagsController < ApplicationController
  skip_before_filter :show_products, :only => :autocomplete
  
  def index
    @tags = Tag.all
  end
  
  def show
    @tag = Tag.find_by_id(params[:id])
    respond_to do |type|
      type.html
      type.js {render :json => @tag}
    end
  end
  
  def create
    @tag = Tag.new(params[:tag])
    if @tag.save
      redirect_to @tag
    else
      render :action => :index
    end
  end
  
  def update
    @tag = Tag.find_by_id(params[:id])
    if @tag.update_attributes(params[:tag])
      flash[:notice] = "Tag updated succesfully"
      redirect_to @tag
    else
      render :action => :show
    end    
  end
  
  def update_in_place
    @tag = Tag.find_by_id(params[:id])
    @tag.send("#{params[:element_id]}=", params[:update_value]) # set a single attribute from an edit-in-place field
    
    if @tag.save
      render :text => params[:update_value]
    else
      errors = @tag.errors.full_messages.join("<br />")
      render :json => { :error => errors }, :status => 422 # render the response object as content type json with HTTP status code of 422 (Unprocessable Entity)
    end
  end
  
  def update_prop_in_place
    @tag = Tag.find_by_id(params[:id])

    # key_or_val will be equal to "key" or "value"
    key_or_val, kvp_id = params[:element_id].split("_")
    
    @kvp = KeyValuePair.find_by_id(kvp_id)
    @kvp.send("#{key_or_val}=", params[:update_value])
    @kvp.save
    render :text => params[:update_value]
  end
  
  def destroy
    Tag.find_by_id(params[:id]).destroy
    redirect_to tags_path
  end
  
  def autocomplete
    case params[:element_id]
    when "tag_hook"
      # hook_names = Tag.all(:select => "hook", :conditions => ["hook LIKE ?", "%#{params[:q]}%"]).map {|x| x.hook }
      hook_names = Tag.all(:select => "hook", :conditions => ["hook LIKE ?", "%#{params[:q]}%"], :limit => 5).map(&:hook)
      render :text => hook_names.join("\n")
    when "tag_location"
      location_names = Tag.all(:select => "location", :conditions => ["location LIKE ?", "%#{params[:q]}%"], :limit => 5).map(&:location)
      render :text => location_names.join("\n")
    else
      render :text => "No autocomplete for this element", :status => 422
    end
  end
  
end