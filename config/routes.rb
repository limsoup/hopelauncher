Hopelauncher::Application.routes.draw do

  # mount Mercury::Engine => '/'

  resources :projects do
    # member do
    #   post 'donate'
    # end
    member do
      get 'dashboard'
      post 'create_message'
    end
    resources :blocks, :donations, :gallery_images
  end
  root :to => 'static_pages#intro'
  match 'faq' => 'static_pages#faq', :via => :get, :as => 'faq'
  match 'help' => 'static_pages#help', :via => :get, :as => 'help'

  # resources :conversations

  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks", :registrations => "users/registrations"}
  resources :users, :only => [:index, :show]

  # match '/sample' => 'messages#samples'

  %w(inbox sentbox drafts deleted).each do |box|
    match "mail/#{box}" => "conversations##{box}", :via => :get
  end
  match 'mail' => 'conversations#inbox', :via => :get

  # match 'messages/:box', :controller => 'conversations', :action => :box, :constraints => {:box => /inbox|outbox|deleted|drafts/ }
  match 'mail/:id' => 'conversations#show', :constraints => {:id => /\d+/}, :as => 'conversation', :via => :get
  match 'mail/:id' => 'conversations#reply', :as => 'messages', :via => :post

  match 'mail/:conversation_id/message/:id' => 'conversations#show_message', :constraints => {:id => /\d+/, :conversation_id => /\d+/ }, :as => :threads_messages

  match 'mail/new' => 'conversations#new'
  match 'mail' => 'conversations#create', :via => :post, :as => 'create_conversation'
  match 'mail' => 'conversations#project_message_create'
  # match 'mail' => 'conversations#reply', :via => :post, :as => 'reply_conversation'

  # match 'messages/create' => 'messages#inbox', :via => :get

  # match 'users/new', :to => 'users#new'

  # match 'blocks/new/:project_id', :to => 'blocks#new', :as => 'new_block'
  
  match 'users/', :to => 'users#index', :as => 'users', :via => :get
  match 'stripe_redirect', :to => 'users#stripe_redirect', :via => :get
  match 'channel.:format', :to => 'static_pages#channel'
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
