class ScreenShotsController < ApplicationController
  
  def create
    @tag = Tag.find(params[:tag_id])
    if @tag.update_attributes(params[:multitrack_tag] || params[:page_view_tag])
      flash[:notice] = "Successfully uploaded a snapshot"
    else
      flash[:error] = @tag.errors.full_messages.first
    end
    redirect_to @tag
  end
  
end
