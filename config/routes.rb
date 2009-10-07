ActionController::Routing::Routes.draw do |map|
  map.resources :tags, :member => { :update_in_place => :put }  
  map.resources :products, :only => [:show]
  map.root :controller => 'tags', :action => 'index'
end