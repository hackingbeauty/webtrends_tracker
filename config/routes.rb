ActionController::Routing::Routes.draw do |map|
  map.resources :tags
  map.root :controller => 'application'
end
