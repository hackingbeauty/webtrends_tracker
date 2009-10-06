class TagsController < ApplicationController
  def index
    @tags = Tag.all
  end
  
  def show
    @tag = Tag.find_by_id(params[:id])
  end
  
  def new
    # @tag = Tag.new
    # render :action => 'show'
  end
  
  def create
    @tag = Tag.new(params[:tag])
    if @tag.save
      redirect_to @tag
    else
      flash[:error] = "Error creating tag"
      render :action => :index
    end
  end
  
end