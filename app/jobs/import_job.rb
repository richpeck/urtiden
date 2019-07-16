############################################################
############################################################
##                 _____                                  ##
##                /  ___|                                 ##
##                \ `--. _   _ _ __   ___                 ##
##                 `--. \ | | | '_ \ / __|                ##
##                /\__/ / |_| | | | | (__                 ##
##                \____/ \__, |_| |_|\___|                ##
##                        __/ |                           ##
##                        |___/                           ##
##                                                        ##
############################################################
############################################################

## Import All ##
## Because there are so many CSV records, we need to async it ##
class ImportJob < ActiveJob::Base
  queue_as :import

  ## Too Many Requests ##
  ## Rescues the update and resubmits to the end of the queue ##
  rescue_from(StandardError) do
    retry_job queue: :import
  end

  ## Perform Queue ##
  ## This allows us to send ID's from Resque/Sidekik and process them sequentially ##
  def perform id, csv

    ## Vars ##
    new_products = []
    @shop = Shop.find id

    ## Show response (might be huge) ##
    ## This is where we should put all the products into the local db ##
    ## Converts allow us to change the "attributes" column to attribs - https://stackoverflow.com/a/37059741/1143732 ##
    CSV.foreach(csv, headers: :first_row, col_sep: ";", header_converters: lambda { |name| {"attributes" => "attribs"}.fetch(name, name).to_sym }) do |product|
      new_products << @shop.products.new(product.to_h)
    end

    ## Products ##
    ## Create values locally ##
    ActiveRecord::Base.logger.silence do
      @shop.products.import new_products, validate: false, on_duplicate_key_update: Rails.env.development? ? { conflict_target: [:id_product], columns: [:stock, :price] } : [:stock, :price] # required to get it working on Heroku
    end

  end

end

############################################################
############################################################
