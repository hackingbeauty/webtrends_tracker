ActionController::Routing::Routes.draw do |map|
  
  map.resource  :screen_shots
  map.resource  :user_session

  map.resources :tags
  
  map.resources :multitrack_tags # do |tags| 
  #     tags.resources :key_value_pairs
  #   end
  
  map.resources :page_view_tags # do |tags| 
  #     tags.resources :key_value_pairs
  #   end

  map.resources :key_value_pairs
  map.resources :products do |product|# nested route
    product.new_multitrack_tag 'multitrack_tags/new', :controller => 'multitrack_tags', :action => 'new'
    product.new_page_view_tag 'page_view_tags/new', :controller => 'page_view_tags', :action => 'new'
  end
  
  map.spreadsheet '/spreadsheet', :controller => 'spreadsheets'
  
  map.root :controller => 'multitrack_tags', :action => 'index'
  
end