Codefoundry::Application.routes.draw do
  
  # global pages
  root :to => 'welcome#index'
  get 'about', :to => 'welcome#about', :as => 'about'
  get 'search', :to => 'welcome#search', :as => 'search'
  get 'faq', :to => 'welcome#faq', :as => 'faq'

  # the current user's account page
  resource :account

  # login/logout/signup
  get 'login', :to => 'user_sessions#new' 
  get 'logout', :to => 'user_sessions#destroy'
  post 'session', :to => 'user_sessions#create'
  get 'signup', :to => 'users#new'

  # route to both the git and svn handlers.  the handlers will be
  # responsible for rendering errors if the request cannot be served (e.g.,
  # if git is requested for a svn repository)
  # FIXME: these trigger "ERROR NameError: uninitialized constant Net::ProtoAuthError"
  # for me - commenting out until the bugs are worked out
  #match 'git(/*params)' => GitHandler.new, :anchor => false
  #match 'svn(/*params)' => SvnHandler.new, :anchor => false

  # repository controller; accessed through both :users and :projects so we
  # build the route in a Proc and pass it to resources later
  repository_routes = Proc.new do
    member do
      # redirection routes
      get :issues # redirects to issue tracker
      get :docs   # redirects to hosted documentation
      get :live   # redirects to live site

      # revisions and commits are synonymous, but try to use the right one for
      # the right repository
      get :commits
      get :revisions

      resources :releases

      # followers?

      # used to perform RESTful commits with tarballs or multiple file uploads
      post :commit

      # :tag is used for a revision, commit, branch, or tag

      # shows a change set
      get ':tag/changes', :to => 'repositories#changes'

      # all repository access should go through show, rather than having a
      # different controller for each access type (blob, folder, commit, etc.);
      # the correct handler will be called inside the RepositoriesController
      get ':tag/*path', :to => 'repositories#show'
    end
  end

  resources :users do
    resources( :repositories, &repository_routes )
  end

  # use /u/... as shorthand for /users/... routes
  resources :users, :as => 'u' do
    resources( :repositories, &repository_routes )
  end

  resources :projects do
    resources( :repositories, &repository_routes )
    resources( :privileges )
  end

  # use /p/... as shorthand for /projects/... routes
  resources :projects, :as => 'p' do
    resources( :repositories, &repository_routes )
    resources( :privileges )
  end

  resources :roles

  # other pages default to the dispatch controller which will figure out what
  # the user wants
  # FIXME: commenting out until dispatch controller exists
  #get '*path', :to => 'dispatch#go'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
