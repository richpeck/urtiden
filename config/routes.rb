########################################
########################################
##    _____            _              ##
##   | ___ \          | |             ##
##   | |_/ /___  _   _| |_ ___  ___   ##
##   |    // _ \| | | | __/ _ \/ __|  ##
##   | |\ \ (_) | |_| | ||  __/\__ \  ##
##   \_| \_\___/ \__,_|\__\___||___/  ##
##                                    ##
########################################
########################################

## Good resource
## https://gist.github.com/maxivak/5d428ade54828836e6b6#merge-engine-and-app-routes

########################################
########################################

## Routes ##
## Since we are using the ShopifyApp gem, we are able to integrate directly ##
Rails.application.routes.draw do

  # => Shopify App
  # => This creates a registration/login system for Shopify's oAuth API
  # => Allows us to create an app which integrates with Shopify
  # => Also needs a root page (for when authenticated)
  root to: 'products#index' # => ShopifyApp (this is used to show the "authenticated" page)

  # => Shopify App Engine
  # => This is used for oAuth etc
  mount ShopifyApp::Engine, at: '/' # => ShopifyApp Engine (required for oAuth etc)

  # => Functionality
  # => This allows us to manage the various products within the system
  resources :products, only: [:index, :update, :show], path: "" do # => Allows us to manage products within the Shopify store
    get :import, on: :collection # => Imports products from the supplier (WWT.it) and shows them in our dashboard area
  end

end

########################################
########################################
