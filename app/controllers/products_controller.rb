class ProductsController < ApplicationController
  
  def index
    @tags = Tag.list(params[:page])
  end
  
  def show
    @product = Product.find(params[:id])
    @order = (params[:order] == "desc") ? "created_at desc" : "created_at asc"
    @multitrack_tags = @product.multitrack_tags.list(params[:multitrack_page], @order)
    @page_view_tags = @product.page_view_tags.list(params[:page_view_page], @order)
    @total_multitrack_tags = @product.multitrack_tags.count
    @total_page_view_tags = @product.page_view_tags.count
  end
  
end