class ProductsController < ApplicationController
  
  def show
    @product = Product.find(params[:id])
    @order = (params[:order] == "desc") ? "created_at desc" : "created_at asc"
    @multitrack_tags = @product.multitrack_tags.find(:all, :order => @order)
    @page_view_tags = @product.page_view_tags.find(:all, :order => @order)
    @total_multitrack_tags = @product.multitrack_tags.find(:all).size
    @total_page_view_tags = @product.page_view_tags.find(:all).size
  end
  
end