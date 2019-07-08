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

  ## Import ##
  ## This imports all products from the API ##
  ## It's a simple method which basically connects to the API endpoint (with credentials) and then populates our DB ##
  def import

    ## curl -k --data \
    ## "data=username%3DUSERNAME%26password%3DPASSWORD%26pid%3DPORTAL ID%26lid%3DLANGUAGE ID" \ ##
    ## Environment/export/csv.php ##
    data = {
      username: Rails.application.credentials.dig(Rails.env.to_sym, :api, :login),
      password: Rails.application.credentials.dig(Rails.env.to_sym, :api, :password),
      pid:      Rails.application.credentials.dig(Rails.env.to_sym, :api, :pid),
      lid:      Rails.application.credentials.dig(Rails.env.to_sym, :api, :lid)
    }

    Rails.logger.info "data=" + URI.encode_www_form(data)
    Rails.logger.info URI.encode(URI.encode_www_form(data))

    ## Allows us to connect to the system ##
    ## We just need to connect to the server and download the CSV for processing ##
    @connection = Faraday.new url: Rails.application.credentials.dig(Rails.env.to_sym, :api, :endpoint)
    response = @connection.post 'csv.php' do |req| # => https://gist.github.com/narath/9e74cb7dd17050c76936fded2861f2d1
       req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
       req.body = "data=" + URI.encode_www_form(data)
    end

    Rails.logger.info response.body

    ## Show response (might be huge) ##
    ## This is where we should put all the products into the local db ##
    Rails.logger.info response.inspect

    ## Nothing to show ##
    ## Just redirect back to index ##
    flash[:notice] = "Products Imported" # => Only valid way to get the flash to show
    redirect_to action: :index

  end

end

############################################################
############################################################
