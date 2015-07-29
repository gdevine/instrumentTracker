InstrumentTracker::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  
    
  resources :models, only: [:index, :show]
  resources :services, only: [:index, :show, :create, :update, :destroy]
  resources :statuses, only: [:index, :show]
  resources :facedeployments, controller: 'statuses', status_type: 'Facedeployment',  only: [:index, :edit, :show, :update, :destroy]
  resources :loans, controller: 'statuses', status_type: 'Loan',  only: [:index, :edit, :show, :update, :destroy]
  resources :losts, controller: 'statuses', status_type: 'Lost',  only: [:index, :edit, :show, :update, :destroy]  
  resources :storages, controller: 'statuses', status_type: 'Storage',  only: [:index, :edit, :show, :update, :destroy]
  resources :deployments, controller: 'statuses', status_type: 'Deployment',  only: [:index, :edit, :show, :update, :destroy]
  resources :retirements, controller: 'statuses', status_type: 'Retirement',  only: [:index, :edit, :show, :update, :destroy]
  
  resources :instruments do
    resources :services,  only: [:index, :new, :edit]
    resources :statuses,  only: [:index]
    resources :facedeployments, controller: 'statuses', status_type: 'Facedeployment',  only: [:index, :new, :create]  
    resources :storages, controller: 'statuses', status_type: 'Storage',  only: [:index, :new, :create]  
    resources :deployments, controller: 'statuses', status_type: 'Deployment',  only: [:index, :new, :create]  
    resources :loans, controller: 'statuses', status_type: 'Loan',  only: [:index, :new, :create]  
    resources :losts, controller: 'statuses', status_type: 'Lost',  only: [:index, :new, :create]  
    resources :retirements, controller: 'statuses', status_type: 'Retirement',  only: [:index, :new, :create]  
  end
  
  root  'static_pages#home'
  match '/about',       to: 'static_pages#about',   via: 'get'
  match '/help',       to: 'static_pages#help',   via: 'get'
  match '/contact',       to: 'static_pages#contact',   via: 'get'
  match '/dashboard',       to: 'static_pages#dashboard',   via: 'get'

  
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
