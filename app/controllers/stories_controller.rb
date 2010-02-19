class StoriesController < ApplicationController
  
  def new
    @tag = Tag.find(params[:tag_id])
    @story = Story.new({ :tag => @tag })
    # Story.create(:name => "EWWWWWWW", :requested_by => "Jeri Beckley", :description => "green eggs and ham", :project_id => "35087")
  end
  
  def create
    # headers['X-TrackerToken'] = "#{self.pivotal_token}"
    
  end
  
end
