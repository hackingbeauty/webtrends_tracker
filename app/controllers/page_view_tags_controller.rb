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
    respond_to do |type|
      if @tag.save
        type.html {redirect_to @tag}
        type.js { render :json => @tag}
      else
        type.html { @product = @tag.product; render :action => 'new' }
        type.js { render :json => @tag.errors.full_messages, :status => :unprocessable_entity }        
      end
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