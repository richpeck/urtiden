############################################################
############################################################
##        _____              _            _               ##
##       | ___ \            | |          | |              ##
##       | |_/ / __ ___   __| |_   _  ___| |_ ___         ##
##       |  __/ '__/ _ \ / _` | | | |/ __| __/ __|        ##
##       | |  | | | (_) | (_| | |_| | (__| |_\__ \        ##
##       \_|  |_|  \___/ \__,_|\__,_|\___|\__|___/        ##
##                                                        ##
############################################################
############################################################
## Populated from vendor API's
## This allows us to match products against Shopify and get all the details sorted properly
############################################################
############################################################

# frozen_string_literal: true

## Products Controller ##
## Allows us to manage imported products with Shopify ##
class ProductsController < ShopifyApp::AuthenticatedController

  ## Index ##
  ## This is the main page they see when they want to match products with their store ##
  def index

    ## The way it works is two-fold ##
    ## Firstly, the user connects to Shopify - this is done via the app ##
    ## This is done because it's the best way to get it working ##
    ## - ##
    ## After this, we are able to populate the dashboard with the user's imported products etc ##
    ## Allowing us to sync them together as required ##
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    
  end
end

############################################################
############################################################
