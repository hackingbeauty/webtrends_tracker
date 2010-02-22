class StoriesController < ApplicationController
  
  def new
    @tag = Tag.find_by_id(params[:tag_id])
    @story = Story.new({ :tag => @tag })
  end
  
  def create
    @tag = Tag.find_by_id(params[:tag][:id])
    @story = Story.new(params[:story].merge({ :tag => @tag }))
    if @story.post_to_pivotal
      flash[:notice] = "Pivotal Story successfully submitted!"
      redirect_to @tag
    else
      flash[:error] = "The Pivotal Story could not be created"
      render :action => 'new'
    end
  end
  
end
