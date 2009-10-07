ActionController::Routing::Routes.draw do |map|
  map.resources :key_value_pairs
  map.resources :tags, 
    :member => { 
      :update_in_place => :put, 
      :update_kvp_in_place => :put 
    },
    :collection => { 
      :autocomplete => :get 
    }
  map.resources :products, :only => [:show]
  map.root :controller => 'tags', :action => 'index'
end