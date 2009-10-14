class ProductsController < ApplicationController
  
  def show
    @product = Product.find(params[:id])
    @order = (params[:order] == "desc") ? "created_at desc" : "created_at asc"
    @tags = @product.tags.find(:all, :order => @order)
  end
  
end