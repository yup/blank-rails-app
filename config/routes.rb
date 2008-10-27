ActionController::Routing::Routes.draw do |map|
  map.resources :sessions
  map.logout 'logout', :controller => 'sessions', :action => 'destroy'

  map.resource :profile
  
  map.root :controller => 'pages'
  map.page ':action', :controller => 'pages'
end
