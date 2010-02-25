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
  
end