ActionController::Routing::Routes.draw do |map|

  map.resources :organizations

  # Authentication
  map.resources :users
  map.resource :session
  map.activate '/activate/:activation_code',  :controller => 'users', :action => 'activate'
  map.forgot   '/forgot',            :controller => 'users',     :action => 'forgot'
  map.reset    '/reset/:reset_code', :controller => 'users',     :action => 'reset',
                                     :requirements => { :reset_code => /\w+/ }

  # Organization mappings go last so they don't take precedence'
  map.resources :tags, :path_prefix => '/:organization_key', :only => :show
  map.resources :people, :path_prefix => '/:organization_key', :collection => { :auto_complete_for_person_full_name => :get }
  map.resources :visits, :path_prefix => '/:organization_key/people/:person_id'
  map.resources :services, :path_prefix => '/:organization_key/people/:person_id'
  map.resources :notes, :path_prefix => '/:organization_key/people/:person_id'

  map.day_visits ':organization_key/visits/:year/:month/:day',
          :controller => 'visits', :action => 'day',
          :requirements => {:year => /\d{4}/, :day => /\d{1,2}/, :month => /\d{1,2}/}

  map.reports ':organization_key/reports', :controller => 'reports', :action => 'index'
  map.report ':organization_key/reports/:action', :controller => 'reports'

  map.with_options :controller => 'organizations' do |organization|
    organization.connect ':organization_key', :action => 'update', :conditions => { :method => :put }
    organization.connect ':organization_key', :action => 'destroy', :conditions => { :method => :delete }
    organization.organization_key ':organization_key', :action => 'show'
    organization.edit_organization_key ':organization_key/edit', :action => 'edit'
  end

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "organizations"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
