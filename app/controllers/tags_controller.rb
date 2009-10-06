class TagsController < ApplicationController
  protect_from_forgery :except => [:update]
  
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
    @tag.send("#{params[:element_id]}=", params[:update_value])
    # puts @tag.send("#{params[:element_id]}")
    
    if @tag.save
      render :text => params[:update_value]
    else
      errors = @tag.errors.full_messages.join("<br />")
      json = { :error => errors }.to_json
      render :json => json, :status => 422 #render the response object as content type json with HTTP status code of 422 (Unprocessable Entity)
    end
  end
  
end