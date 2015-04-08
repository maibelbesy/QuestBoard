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
  get '/users/:id' => 'profile#index', as: :user

  # Routes for Quests

  get '/quests' => 'quests#index', as: :quests

  get '/quests/new' => 'quests#new', as: :new_quest
  get '/quests/pending_quests' => 'quests#pending_quests', as: :pending_quests
  get '/quests/general_quests' => 'quests#general_quests', as: :general_quests
  get '/quests/:id' => 'quests#show', as: :quest
  get '/quests/edit/:id' => 'quests#edit', as: :edit_quest
  post '/quests/accept/:id' => 'quests#accept', as: :accept_quest
  post '/quests/reject/:id' => 'quests#reject', as: :reject_quest
  post '/quests/edit/:id' => 'quests#update', as: :update_quest
  post '/quests/new' => 'quests#create', as: :create_quest
  delete '/quests/:id'=> 'quests#destroy', as: :delete_quest
  
  get '/quests/review/:id' => 'quests#review', as: :review_quest
  post '/quests/review/:id' => 'quests#add_review', as: :add_review_quest
  

  # Routes for Notifications
  get '/notifications' => 'notifications#index', as: :notifications

  # Routes for the account web pages
  get '/users/edit/:id' => 'account#edit', as: :user_edit
  # get '/users/:id' => 'account#show', as: :user
  post '/users/edit/:id' => 'account#update', as: :user_update

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
  get 'auth/failure', to: redirect('http://www.google.com')
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
<<<<<<< HEAD

=======
>>>>>>> d615b3ccfa2fab019359ca4d47452cddf4bc73ff
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
<<<<<<< HEAD

=======
>>>>>>> d615b3ccfa2fab019359ca4d47452cddf4bc73ff
# Example resource route with concerns:
#   concern :toggleable do
#     post 'toggle'
#   end
#   resources :posts, concerns: :toggleable
#   resources :photos, concerns: :toggleable
<<<<<<< HEAD

=======
>>>>>>> d615b3ccfa2fab019359ca4d47452cddf4bc73ff
# Example resource route within a namespace:
#   namespace :admin do
#     # Directs /admin/products/* to Admin::ProductsController
#     # (app/controllers/admin/products_controller.rb)
#     resources :products
#   end
end
