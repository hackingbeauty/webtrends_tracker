class PageViewTagsController < ApplicationController
  
  before_filter :load_tag
  before_filter :load_product
  
  def show
    respond_to do |type|
      type.html
      type.js {render :json => @tag}
    end
  end
  
  def new
    @tag = PageViewTag.new
  end
  
  def create
    @tag = PageViewTag.new(params[:page_view_tag])
    if @tag.save
      redirect_to @tag
    else
      @product = @tag.product
      render :action => 'new'
    end
  end
  
  def destroy    
    @tag.destroy
    redirect_to @tag.product
  end

  private
  
  def load_tag
    @tag = PageViewTag.find(params[:id]) if params[:id]
  end
  
  def load_product
    @product = Product.find(params[:product_id]) if params[:product_id]
    if @tag
      @product ||= @tag.product 
    end
  end

end