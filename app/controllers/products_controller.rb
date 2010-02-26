class ProductsController < ApplicationController
  
  def index
    @tags = Tag.list(params[:page])
  end
  
  def show
    @product = Product.find(params[:id])
    @multitrack_tags = @product.multitrack_tags.ordered.list(params[:multitrack_page])
    @page_view_tags =  @product.page_view_tags.ordered.list(params[:page_view_page])
    @total_multitrack_tags = @product.multitrack_tags.count
    @total_page_view_tags = @product.page_view_tags.count
  end
  
  def new
    @product = Product.new
  end
  
  def create
    @product = Product.new(params[:product])
    if @product.save
      flash[:notice] = "Product created successfully"
      redirect_to @product
    else
      flash[:error] = "Could not create product - boo hoo"
      render :action => 'new'
    end
  end
  
  def edit
    @product = Product.find_by_id(params[:id])
  end
  
  def update
    @product = Product.find_by_id(params[:id])

    if @product.update_attributes(params[:product])
      flash[:notice] = "Product updated successfully"
      redirect_to @product
    else
      flash[:error] = "Could not update product"
      render :action => 'edit'
    end
  end
  
  def destroy
    @product = Product.find_by_id(params[:id])
    @product.destroy
    redirect_to products_path
  end
    
end