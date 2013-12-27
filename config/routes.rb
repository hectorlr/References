References::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'home#index'

   get '/download', to: 'download#index'
   post '/download', to: 'download#index'

   get '/upload', to: 'upload#index'
   post '/upload', to: 'upload#index'

   get '/update', to: 'update#index'
   post '/update', to: 'update#index'

   get '/information', to: 'information#index'
   post '/information', to: 'information#index'

   resources :download do
     post :download, on: :collection
   end

   resources :home do
     post :downloadErrorFile, on: :collection
   end

   resources :information do
     post :downloadInformationFile, on: :collection
   end

   resources :update do
     post :addPerson, on: :collection
     post :deletePerson, on: :collection
     post :addReference, on: :collection
     post :deleteReference, on: :collection
     post :changeReference, on: :collection
   end

   # Example of regular route:
    post :action=>'onUpload', :controller=>'upload'





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
