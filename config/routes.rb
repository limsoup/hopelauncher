Hopelauncher::Application.routes.draw do

  # mount Mercury::Engine => '/'

  resources :projects do
    # member do
    #   post 'donate'
    # end
    member do
      get 'dashboard', :as => 'dashboard'
      get 'project_communications', :as => 'project_communications'
      # get 'donations', :as => 'donations'
      get 'edit_gallery', :as => 'edit_gallery'
      get 'edit_content', :as => 'edit_content'
      get 'edit_stretch_goals', :as => 'edit_stretch_goals'
      get 'edit_settings', :as => 'edit_settings'
      get 'staging', :as => 'staging'
      get 'submit', :as => 'submit'
      # get 'updates', :as => 'updates'
      # get 'rewards', :as => 'rewards'
      # get 'participants', :as => 'participants'
      post 'create_message', :as => 'create_message'
      # following
    end
    resources :gallery_images#, :updates, :followings
    resources :updates, :only => [:create, :edit, :update, :destroy, :index]
    resources :rewards, :only => [:create, :destroy, :index]
    resources :project_participants, :only => [:create, :destroy, :index, :show]
    resources :donations, :only => [:create, :index, :show, :new]
  end


match '/projects/:project_id/rewards/tracking' => 'rewards#tracking', :as => 'project_tracking_rewards'
match '/projects/:project_id/participants/tracking' => 'project_participants#tracking', :as => 'project_tracking_participants'
match '/projects/:project_id/participants/import' => 'project_participants#import', :as => 'project_import_participants'


match '/projects/:project_id/donations/:id' => 'donations#show', :as => 'project_donation'

match '/projects/:project_id/donations/:id/process_donation' => 'donations#process_donation', :as => 'process_donation_project'
match '/projects/:project_id/donations/:id/review_donation' => 'donations#review_donation', :as => 'review_donation_project'

  match '/projects/:project_id/followings/create' => 'followings#create', :as => 'create_project_following'
  match '/projects/:project_id/followings/:id/destroy' => 'followings#destroy', :as => 'destroy_project_following'

  match 'admin/users' => 'admin#users', :as => 'users_admin'
  match 'admin/projects' => 'admin#projects', :as => 'projects_admin'
  match 'admin/donations' => 'admin#donations', :as => 'donations_admin'
  match 'admin/approve_user/:id' => 'admin#approve_user', :as => 'approve_user'
  match 'admin/reject_user/:id' => 'admin#reject_user', :as => 'reject_user'
  match 'admin/approve_project/:id' => 'admin#approve_project', :as => 'approve_project'
  match 'admin/reject_project/:id' => 'admin#reject_project', :as => 'reject_project'

  root :to => 'static_pages#intro'
  match 'faq' => 'static_pages#faq', :via => :get, :as => 'faq'
  match 'terms_of_service' => 'static_pages#terms_of_service', :via => :get, :as => 'terms_of_service'
  match 'privacy_policy' => 'static_pages#privacy_policy', :via => :get, :as => 'privacy_policy'
  match 'help' => 'static_pages#help', :via => :get, :as => 'help'

  # resources :conversations

  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks", :registrations => "users/registrations", :sessions => "users/sessions"}
  devise_scope :user do
    match 'users/:id/edit_account' => 'users/registrations#edit_account', :as => 'edit_account_user', :via => :get
    match 'users/:id/edit_profile' => 'users/registrations#edit_profile', :as => 'edit_profile_user', :via => :get
    match 'users/:id/submit' => 'users/registrations#submit', :as => 'submit_user', :via => :get
    # match 'users/:id/projects' => 'users/registrations#projects', :as => 'projects_user', :via => :get
  end

  resources :users, :only => [:index, :show] do
    member do
      get 'projects', :as => 'projects'
    end
    # member do
    #   get 'edit_account', :as => 'edit_account'
    #   get 'edit_profile', :as => 'edit_profile'
    # end
  end



  %w(inbox sentbox trash).each do |box|
    match "mail/#{box}" => "conversations##{box}", :via => :get, :as => "#{box}"
    match "mail/projects/:project_id/#{box}" => "conversations#project_#{box}", :via => :get, :as => "project_#{box}"
    # match "mail/projects/:project_id/#{box}/new" => "conversations#new_project_#{box}_conversation", :via => :get, :as => "new_project_#{box}_conversation"
    # match "mail/projects/:project_id/#{box}/:id" => "conversations#show_project_#{box}_conversation", :via => :get, :as => "project_#{box}_conversation"
    # match "mail/projects/:project_id/#{box}/" => "conversations#create_project_#{box}_conversation", :via => :post, :as => "project_#{box}_conversation"
    # match "mail/projects/:project_id/#{box}/:id" => "conversations#reply_project_#{box}_conversation", :via => :puAt, :as => "reply_project_#{box}_conversation"
    match "mail/user/#{box}" => "conversations#user_#{box}", :via => :get, :as => "user_#{box}"
    # match "mail/user/#{box}/new" => "conversations#new_user_#{box}_conversation", :via => :get, :as => "new_user_#{box}_conversation"
    # match "mail/user/#{box}/:id" => "conversations#show_user_#{box}_conversation", :via => :get, :as => "user_#{box}_conversation"
    # match "mail/user/#{box}/" => "conversations#create_user_#{box}_conversation", :via => :post, :as => "user_#{box}_conversation"
    # match "mail/user/#{box}/:id" => "conversations#reply_user_#{box}_conversation", :via => :put, :as => "reply_user_#{box}_conversation"
  end
  match "mail/projects/:project_id/new" => "conversations#new_project_conversation", :via => :get, :as => "new_project_conversation"
  match "mail/projects/:project_id/:id" => "conversations#show_project_conversation", :via => :get, :as => "project_conversation"
  match "mail/projects/:project_id/:id" => "conversations#reply_project_conversation", :via => :put
  match "mail/projects/:project_id/:id" => "conversations#delete_project_conversation", :via => :delete
  match "mail/projects/:project_id/" => "conversations#create_project_conversation", :via => :post, :as => "project_conversations"

  match "mail/user/new" => "conversations#new_user_conversation", :via => :get, :as => "new_user_conversation"
  match "mail/user/:id" => "conversations#show_user_conversation", :via => :get, :as => "user_conversation"
  match "mail/user/:id" => "conversations#reply_user_conversation", :via => :put
  match "mail/user/:id" => "conversations#delete_user_conversation", :via => :delete
  match "mail/user/" => "conversations#create_user_conversation", :via => :post, :as => "user_conversations"

  # match "mail/" => "conversations#user_create", :via => :post, :as => "user_create"
  # match "mail/:id" => "conversations#user_reply", :via => :put, :as => "user_reply"
  # match "mail/projects/:project_id" => "conversations#project_create", :via => :post, :as => "project_create"
  match 'conversations/recipients' => 'conversations#recipients', :via => :get
  match 'conversations/project_recipients' => 'conversations#project_recipients', :via => :get

  # match '/sample' => 'messages#samples'

  #-- big routing and controller change --#
  ##%w(inbox sentbox drafts deleted).each do |box|
  ##  match "mail/#{box}" => "conversations##{box}", :via => :get, :as => "#{box}"
  ##end
  ##match 'mail' => 'conversations#inbox', :via => :get
  #-- /big routing and controller change --#

  # match 'messages/:box', :controller => 'conversations', :action => :box, :constraints => {:box => /inbox|outbox|deleted|drafts/ }
  
  #-- big routing and controller change --#
  match 'mail/:id' => 'conversations#show', :constraints => {:id => /\d+/}, :as => 'conversation', :via => :get
  ##match 'mail/:id' => 'conversations#reply', :as => 'conversations', :via => :put

  ##match 'mail/:conversation_id/message/:id' => 'conversations#show_message', :constraints => {:id => /\d+/, :conversation_id => /\d+/ }, :as => :threads_messages

  # match 'mail/user/new' => 'conversations#user_new_conversation', :via => :get, :as => 'user_new_conversation'
  # match 'mail/projects/:project_id/new' => 'conversations#user_new_conversation', :via => :get, :as => 'project_new_conversation'

  ##match 'mail' => 'conversations#create', :via => :post, :as => 'create_conversation'
  ##match 'mail' => 'conversations#project_message_create'
  ##match 'conversations/recipients' => 'conversations#recipients', :via => :get
  #-- /big routing and controller change --#

  # match 'mail' => 'conversations#reply', :via => :post, :as => 'reply_conversation'

  # match 'messages/create' => 'messages#inbox', :via => :get

  # match 'users/new', :to => 'users#new'

  # match 'blocks/new/:project_id', :to => 'blocks#new', :as => 'new_block'
  
  match 'users/', :to => 'users#index', :as => 'users', :via => :get
  # match 'stripe_redirect', :to => 'users#stripe_redirect', :via => :get
  match 'channel.:format', :to => 'static_pages#channel'

  match '/:short_path', :to => 'projects#by_short_path', :via => :get
  # resources :users do
  #   get 'home'
  # end

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  #match ':controller(/:action(/:id))(.:format)'
end
