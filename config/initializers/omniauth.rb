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

# => Middleware 
Rails.application.config.middleware.use OmniAuth::Builder do

  # => Shopify oAuth
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

############################################
############################################
