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
  root to: 'products#index' # => ShopifyApp (this is used to show the "authenticated" page)
  mount ShopifyApp::Engine, at: '/' # => ShopifyApp Engine (required for oAuth etc)
end

########################################
########################################
