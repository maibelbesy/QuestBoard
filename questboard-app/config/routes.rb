Rails.application.routes.draw do

  get 'sessions/new'

   
  post   '/login'   => 'sessions#create' , as: :login_user
  delete '/logout'  => 'sessions#destroy'


  get '/profile/index'
  get '/users/:id' => 'profile#index'


  # Routes for Quests
  root 'quests#index'

  get '/quests' => 'quests#index', as: :quests
  get '/quests/new' => 'quests#new', as: :new_quest
  get '/quests/:id' => 'quests#show', as: :quest
  get '/quests/edit/:id' => 'quests#edit', as: :edit_quest
  post '/quests/edit/:id' => 'quests#update', as: :update_quest
  post '/quests/new' => 'quests#create', as: :create_quest
  delete '/quests/post/:id'=> 'quests#destroy', as: :delete_quest

  get '/login' => 'sessions#login', as: :login
  get '/signup' => 'sessions#register', as: :register
  post '/signup' => 'sessions#register_user', as: :register_user





  delete '/quests/delete/:id' =>'quests#destroy'



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Routes for the account web pages
  get '/users/edit/:id' => 'account#edit', as: :user_edit
  get '/users/:id' => 'account#show', as: :user
  post '/users/edit/:id' => 'account#update', as: :user_update

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
