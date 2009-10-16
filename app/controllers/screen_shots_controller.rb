class ScreenShotsController < ApplicationController
  
  def create
    @tag = Tag.find(params[:tag_id])
    if @tag.update_attributes(params[:tag])
      flash[:notice] = "Successfully uploaded a snapshot"
    else
      flash[:error] = @tag.errors.full_messages.first
    end
    redirect_to tag_path(@tag)
  end
  
end
