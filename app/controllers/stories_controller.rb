class StoriesController < ApplicationController
  
  def new
    Story.create(:name => "Sam I Am", :requested_by => "Mark Muskardin", :description => "green eggs and ham", :project_id => "35087")
    redirect_to products_path
  end
  
end
