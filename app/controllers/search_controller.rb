class SearchController < ApplicationController
  
  def index
    term = params[:search_input]
    @tags = Tag.search(term).paginate({:page => params[:tags_page], :order => :type })
    @kvps = KeyValuePair.search(term).paginate({ :page => params[:kvps_page] })
  end
  
end