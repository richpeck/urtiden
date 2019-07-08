############################################
############################################
##    ____ _                 _  __        ##
##  /  ___| |               (_)/ _|       ##
##  \ `--.| |__   ___  _ __  _| |_ _   _  ##
##   `--. \ '_ \ / _ \| '_ \| |  _| | | | ##
##  /\__/ / | | | (_) | |_) | | | | |_| | ##
##  \____/|_| |_|\___/| .__/|_|_|  \__, | ##
##                    | |           __/ | ##
##                    |_|          |___/  ##
##                                        ##
############################################
############################################
## This was added by the ShopifyApp gem
## It stores any new "stores" linked to the app via the Shopify oAuth process
############################################
############################################

# => Shopify
# => Requires autoloading of models etc
if Object.const_defined?("ShopifyApp")

  # => Shopify App Auth
  ShopifyApp.configure do |config|
    config.application_name = Rails.application.credentials.dig(:shopify, :name)
    config.api_key          = Rails.application.credentials.dig(:shopify, :api)
    config.secret           = Rails.application.credentials.dig(:shopify, :secret)
    config.scope            = "write_products" # Consult this page for more scope options:
                                               # https://help.shopify.com/en/api/getting-started/authentication/oauth/scopes
    config.embedded_app = true
    config.after_authenticate_job = false
    config.api_version = "2019-07"
    config.session_repository = Shop
  end

end ## const_defined?

############################################
############################################
