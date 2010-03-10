ActionController::Routing::Routes.draw do |map|

  map.resources :landgraf_libraries, :only => [:index,:show] do |lan|
    lan.resources :landgraf_expression_levels, :only => [:index]
  end
  
end
