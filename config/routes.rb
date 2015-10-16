Rails.application.routes.draw do
 resource :payments
  #devise_for :users
  get 'welcome/index'
  get 'payment_paypal' => 'payments#payment_paypal'
  get 'payment_stripe' => 'payments#payment_stripe'
  get 'payment_with_2co' => 'payments#payment_with_2co'
  get 'payment_with_2co_complete' => 'payments#payment_with_2co_complete'
  get 'payment_with_paypal' => 'payments#payment_with_paypal'
  get 'payment_with_stripe' => 'payments#payment_with_stripe'
  get 'payment_cancel' => 'payments#payment_cancel'
  get 'payment_with_britnee' => 'payments#payment_with_britnee'
  post 'payment_britnee' => 'payments#payment_britnee'
  get 'payment_success' => 'payments#paypal_success'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
    root 'welcome#index'
    get 'devise' => 'welcome#devise'
    get 'facebook' => 'welcome#facebook'
    get 'facebook_share' => 'welcome#facebook_share'
    get 'gmail' => 'welcome#gmail'
    get 'gmail_share' => 'welcome#gmail_share'
    get 'twitter' => 'welcome#twitter'
    get 'twitter_share' => 'welcome#twitter_share'
    get 'opengraph' => 'welcome#opengraph'
    get 'dashboard' => 'welcome#dashboard'
    get 'home_page' => 'welcome#home_page'
    get 'un_sub' => 'welcome#un_sub'

   devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
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
