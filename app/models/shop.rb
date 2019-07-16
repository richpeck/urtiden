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

    ## Associations ##
    has_many :imports,  dependent: :delete_all # => required to save CSV data
    has_many :products, dependent: :delete_all
    has_many :syncs,    dependent: :delete_all

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
      syncs.where.not(jobs_counter: 0).first || nil
    end

  #####################################
  #####################################

    ## Import ##
    ## Define var as argument ##
    def import new_products=[]

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
      ## https://stackoverflow.com/a/9995704/1143732 ##
      begin

        ## Get file and download to local system ##
        ## larve CSV files - https://dalibornasevic.com/posts/68-processing-large-csv-files-with-ruby ##
        raw = RestClient::Request.execute(
          method:       :post,
          url:          Rails.application.credentials.dig(Rails.env.to_sym, :api, :endpoint) + "csv.php",
          payload:      URI.encode_www_form({"data": params}),
          raw_response: true
        )

        ## Show response (might be huge) ##
        ## This is where we should put all the products into the local db ##
        ## Converts allow us to change the "attributes" column to attribs - https://stackoverflow.com/a/37059741/1143732 ##
        csv = CSV.foreach(raw.file.path, headers: :first_row, col_sep: ";", header_converters: lambda { |name| {"attributes" => "attribs"}.fetch(name, name).to_sym }).map(&:to_h)

        ## Import ##
        ## Allows us to import into the db ##
        ## batch_size looks like it could help ##
        products.import csv, batch_size: 1000, validate: false, on_duplicate_key_update: Rails.env.development? ? { conflict_target: [:id_product], columns: [:stock, :price] } : [:stock, :price]

      rescue RestClient::ExceptionWithResponse => e
        Rails.logger.info e.response
      end

      ## Return ##
      return CSV.read(raw.file, headers: true) || products

    end

  #####################################
  #####################################

end

############################################
############################################
