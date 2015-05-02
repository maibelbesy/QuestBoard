Rails.application.routes.draw do

# The priority is based upon order of creation: first created -> highest priority.
# See how all your routes lay out with "rake routes".


# get 'sessions/new'

  root 'quests#index'
  # Session routes
  get '/login' => 'sessions#login', as: :login
  post '/login'   => 'sessions#create' , as: :login_user
  get '/signup' => 'sessions#register', as: :register
  post '/signup' => 'sessions#register_user', as: :register_user
  get '/logout'  => 'sessions#destroy', as: :logout_user
  get '/send_verify' => 'sessions#send_verify'
  get '/verify_email' => 'sessions#verify_email'
  get '/reset_password' => 'sessions#reset_password', as: :reset_password
  post '/forgot_password' => 'sessions#forgot_password', as: :forgot_password
  get '/reset_password' => 'sessions#send_password', as: :send_password
  # Routes for Quests

  get '/' => 'quests#index', as: :quests

  get '/quests/new' => 'quests#new', as: :new_quest
  get '/quests/pending_quests' => 'quests#pending_quests', as: :pending_quests
  get '/quests/general_quests' => 'quests#general_quests', as: :general_quests
  get '/quests/my_quests' => 'quests#my_quests', as: :my_quests
  get '/quests/assigned_quests' => 'quests#assigned_quests', as: :assigned_quests
  get '/quests/:id' => 'quests#show', as: :quest
  get '/quests/edit/:id' => 'quests#edit', as: :edit_quest
  post '/quests/accept/:id' => 'quests#accept', as: :accept_quest
  post '/quests/reject/:id' => 'quests#reject', as: :reject_quest
  post '/quests/edit/:id' => 'quests#update', as: :update_quest
  post '/quests/new' => 'quests#create', as: :create_quest
  delete '/quests/:id'=> 'quests#destroy', as: :delete_quest

  
  get '/quests/review/:id' => 'quests#review', as: :review_quest
  post '/quests/review/:id' => 'quests#add_review', as: :add_review_quest
  resources :comments

  # Routes for Notifications
  get '/notifications' => 'notifications#index', as: :notifications
  post '/notifications' => 'notifications#seen'

  # Routes for the account web pages
  
  get '/users/:id' => 'users#show', as: :user
  get '/users/edit/:id' => 'users#edit', as: :edit_user
  post '/users/edit/:id' => 'users#update', as: :user_update

  # Routes for tasks
  get '/quests/task/:id' => 'task#index', as: :task
  get '/quests/task/add/:id' => 'task#create', as: :create_task
  post '/quests/task/add/:id' => 'task#create_task', as: :add_task
  delete '/quests/task/:id' => 'task#destroy', as: :delete_task
  
  #Routes for updating the status of a Quest
  get '/quests/:id/:string' => 'quests#status', as: :status_quest
  resources :users

  get 'auth/:provider/callback' => 'sessions#google_create', as: :google_signin
  # get 'auth/:provider/callback', to: redirect('http://www.google.com'), as: :google_signin
  get '/disconnect_google' => 'sessions#google_delete', as: :google_delete
  get 'auth/failure', to: redirect('/')
# You can have the root of your site routed with "root"
# root 'welcome#index'

# Example of regular route:
#   get 'products/:id' => 'catalog#view'

# Example of named route that can be invoked with purchase_url(id: product.id)
#   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase



# You can have the root of your site routed with "root"
# root 'welcome#index'
# Example of regular route:
#   get 'products/:id' => 'catalog#view'
# Example of named route that can be invoked with purchase_url(id: product.id)
#   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

# Example resource route (maps HTTP verbs to controller actions automatically):
#   resources :products

# Example resource route with options:
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
# Example resource route with sub-resources:
#   resources :products do
#     resources :comments, :sales
#     resource :seller
#   end

# Example resource route with more complex sub-resources:
#   resources :products do
#     resources :comments
#     resources :sales do
#       get 'recent', on: :collection
#     end
#   end
# Example resource route with concerns:
#   concern :toggleable do
#     post 'toggle'
#   end
#   resources :posts, concerns: :toggleable
#   resources :photos, concerns: :toggleable

# Example resource route within a namespace:
#   namespace :admin do
#     # Directs /admin/products/* to Admin::ProductsController
#     # (app/controllers/admin/products_controller.rb)
#     resources :products
#   end


  # Routes for the account web pages
  

  # resources :users
  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

end
