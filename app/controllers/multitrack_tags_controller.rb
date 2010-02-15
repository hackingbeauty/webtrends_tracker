class MultitrackTagsController < ApplicationController

  before_filter :load_tag
  before_filter :load_product

  def index
    @tags = MultitrackTag.ordered
  end
  
  def show
    respond_to do |type|
      type.html
      type.js {render :json => @tag}
    end
  end
  
  def new
    @tag = MultitrackTag.new
  end
  
  def edit
  end
  
  def create
    @tag = MultitrackTag.new(params[:multitrack_tag])
    if @tag.save
      redirect_to @tag
    else
      @product = @tag.product
      render :action => 'new'
    end
  end
  
  def update
    if @tag.update_attributes(params[:tag])
      flash[:notice] = "Tag updated succesfully"
      redirect_to @tag
    else
      render :action => "edit"
    end    
  end
  
  def destroy
    @tag.destroy
    redirect_to tags_path
  end
  
  private
  
  def load_tag
    @tag = MultitrackTag.find(params[:id]) if params[:id]
  end
  
  def load_product
    @product = Product.find(params[:product_id]) if params[:product_id]
    if @tag
      @product ||= @tag.product 
    end
  end
  
end