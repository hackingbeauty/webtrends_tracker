ActionController::Routing::Routes.draw do |map|
  
  map.resource  :screen_shots
  map.resource  :user_session
  map.resources :tags do |tags|
    tags.resources :key_value_pairs
  end
  map.resources :key_value_pairs
  map.resources :products do |product|
    product.new_tag 'tags/new', :controller => 'tags', :action => 'new'
  end
  map.root :controller => 'tags', :action => 'index'
  
end