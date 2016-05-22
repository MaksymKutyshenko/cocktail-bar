Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'selection_table#index'
  resources :welcome, only: [:show, :index]
  resources :selection_table, only: [:show, :select]
  resources :ordered_cocktails, only: [:destroy]
  get 'cocktail/:id' => 'welcome#show', as: :purchase
  get 'search_by_product(/:product)' => 'welcome#index', as: :search_by_product
  get 'addtocart/:id' => 'welcome#add_to_cart', as: :add_to_cart
  get 'cart', to: 'cart#show'
  get 'checkout', to: 'cart#checkout'
  get 'call', to: 'welcome#call_waiter'
  get 'select_table/:id' => 'selection_table#select', as: :select_table

  get "/images/thumbs/:id/:dims.jpg", to: "welcome#tumbs"


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products, :ingridients
  #     resources  :cocktails do
  #       resources :ingridients
  #       end
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  # collection do
  #   get 'search'
  # end
  #end

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
  namespace :admin do
    resources :sessions, only: [:new, :create, :destroy]
    match '/signin', to: 'sessions#new', via: 'get'
    match '/signout', to: 'sessions#destroy', via: 'delete'
    match '/signup', to: 'users#new', via: 'get'

    resources :users, :products, :ingridients, :waiters, :tables

    resources :cocktails do
      resources :ingridients
    end

    match 'products/:name/:direction' => 'products#index',  via: 'get', as: :order_products
    match 'cocktails/:name/:direction' => 'cocktails#index', via: 'get', as: :order_cocktails

    match 'waiters/:id/update_tables' => 'waiters#update_tables',  via: 'post', as: :update_waiter_tables





    #     # Directs /admin/products/* to Admin::ProductsController
    #     # (app/controllers/admin/products_controller.rb)
    #     resources :products
  end

  namespace :api do
    namespace :v1 do
      resources :waiter
    end
  end

  namespace :employees do
    root 'waiter_workspace#index'
    resources :waiter_workspace, only: [:index]
    get 'waiter_workspace/clear_table' => 'waiter_workspace#clear_table', as: :clear_table
    get 'waiter_workspace/answer_alarm' => 'waiter_workspace#answer_alarm', as: :answer_alarm
    get 'waiter_workspace/status_update' => 'waiter_workspace#status_update', as: :status_update
  end
end
