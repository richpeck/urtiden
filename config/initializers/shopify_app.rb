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

  ## This is required to call the FL::SHOPIFY app credentials stored on file ##
  config.before_initialize do

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

  end ## before_initialize

  ###############################
  ###############################

  ## OmniAuth ##
  ## Should have been an initializer but whatever ##
  if Object.const_defined?("OmniAuth")
    initializer :shopify do |app|

      ## Provider Setup for OmniAuth ##
      app.middleware.use OmniAuth::Builder do
        provider :shopify,
          ShopifyApp.configuration.api_key,
          ShopifyApp.configuration.secret,
          scope: ShopifyApp.configuration.scope,
          setup: lambda { |env|
            strategy = env['omniauth.strategy']

            shopify_auth_params = strategy.session['shopify.omniauth_params']&.with_indifferent_access
            shop = if shopify_auth_params.present?
              "https://#{shopify_auth_params[:shop]}"
            else
              ''
            end

            strategy.options[:client_options][:site] = shop
            strategy.options[:old_client_secret] = ShopifyApp.configuration.old_secret
          }
      end

    end ## initializer
  end ## const_defined?
end ## const_defined?

############################################
############################################
