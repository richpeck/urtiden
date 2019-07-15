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

class Shop < ActiveRecord::Base
  include ShopifyApp::SessionStorage

  #####################################
  #####################################

    ## Virtual Attribute ##
    attr_accessor :imported

  #####################################
  #####################################

    ## Associations ##
    has_many :products, dependent: :delete_all
    has_many :queues, class_name: "Sync", dependent: :delete_all

  #####################################
  #####################################

    ## Shopify ##
    def api_version
      ShopifyApp.configuration.api_version
    end

  #####################################
  #####################################

    ## Queue Size ##
    def queue_size
      queues.where(finished_at: nil).pluck(:queue_size).first || 0
    end

  #####################################
  #####################################

    ## Import ##
    def import

      ## curl -k --data \
      ## "data=username%3DUSERNAME%26password%3DPASSWORD%26pid%3DPORTAL ID%26lid%3DLANGUAGE ID" \ ##
      ## Environment/export/csv.php ##
      params = {
        username: Rails.application.credentials.dig(Rails.env.to_sym, :api, :login),
        password: Rails.application.credentials.dig(Rails.env.to_sym, :api, :password),
        pid:      Rails.application.credentials.dig(Rails.env.to_sym, :api, :pid),
        lid:      Rails.application.credentials.dig(Rails.env.to_sym, :api, :lid)
      }.to_query

      ## Allows us to connect to the system ##
      ## We just need to connect to the server and download the CSV for processing ##
      @connection = Faraday.new url: Rails.application.credentials.dig(Rails.env.to_sym, :api, :endpoint)
      response = @connection.post 'csv.php' do |req| # => https://gist.github.com/narath/9e74cb7dd17050c76936fded2861f2d1
         req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
         req.body = URI.encode_www_form({"data": params})
      end

      ## Show response (might be huge) ##
      ## This is where we should put all the products into the local db ##
      ## Converts allow us to change the "attributes" column to attribs - https://stackoverflow.com/a/37059741/1143732 ##
      csv = CSV.parse(response.body, headers: :first_row, col_sep: ";", header_converters: lambda { |name| {"attributes" => "attribs"}.fetch(name, name).to_sym }).map(&:to_h)

      ## Convert CSV elements into Product instances ##
      ## This is mainly for validation purposes ##
      new_products = []

      ## Cycle through each of the newly created records ## ## csv.uniq.take(1000) - staging ##
      csv.uniq.each do |product|
        new_products << products.new(product)
      end

      ## Products ##
      ## Create values locally ##
      products.import new_products, validate: false, on_duplicate_key_update: Rails.env.development? ? { conflict_target: [:id_product], columns: [:stock, :price] } : [:stock, :price] # required to get it working on Heroku

      ## Return ##
      return products

    end

  #####################################
  #####################################


end

############################################
############################################
