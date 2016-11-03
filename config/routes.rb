Rails.application.routes.draw do

  

 resources :bot, only: [:show] do
  resources :question_answers
end

  get 'user/user'

  get 'user/edit'

  get 'user/update'

  root   'static_pages#home'

  #ALL USER ROUTES BELOW
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, controller: "clearance/users", only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  get '/users/:id' => 'users#user', as: "user"
 
  resources :users, only: [:edit,:update]

  get "/auth/:provider/callback" =>"sessions#create_from_omniauth"

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"
  

#prototype routes (to remove/change later)
  get 'webhook' => 'bot#webhook'
 post 'webhook' => 'bot#receive_message'

 get 'webhook2' => 'webhook2#webhook'
 post 'webhook2' => 'webhook2#receive_message'

#starting the structure of the app
 get'/start' => 'bot#start', as: "start"
 get '/start2' =>'bot#start2', as: "start2"

 post '/createbot' =>'bot#create'
 get '/bots/:uri' => 'bot#show' #this is the generic self generated url for all web callbacks per each bot
post '/bots/:uri' => 'bot#receive_message'

get 'questions_answers/create_story' => "questions_answers#create_story", as: "create_story"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

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
