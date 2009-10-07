class TagsController < ApplicationController
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
  
end