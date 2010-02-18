class StoriesController < ApplicationController
  
  def new
    Story.create(:name => "EWWWWWWW", :requested_by => "Jeri Beckley", :description => "green eggs and ham", :project_id => "35087")
    # redirect_to products_path
  end
  
end
