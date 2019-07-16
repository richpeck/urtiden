############################################################
############################################################
##          _____                           _             ##
##         |_   _|                         | |            ##
##           | | _ __ ___  _ __   ___  _ __| |_           ##
##           | || '_ ` _ \| '_ \ / _ \| '__| __|          ##
##          _| || | | | | | |_) | (_) | |  | |_           ##
##          \___/_| |_| |_| .__/ \___/|_|   \__|          ##
##                         | |                            ##
##                         |_|                            ##
##                                                        ##
############################################################
############################################################

## Import ##
## Because there are so many CSV records, we need to async it ##
class ImportJob < ActiveJob::Base
  queue_as :import

  ## Too Many Requests ##
  ## Rescues the update and resubmits to the end of the queue ##
  #rescue_from(StandardError) do
  #  retry_job queue: :import
  #end

  ## Perform Queue ##
  ## This allows us to send ID's from Resque/Sidekik and process them sequentially ##
  def perform shop, product

    ## Vars ##
    @shop = Shop.find shop
    @import = @shop.imports.find product

    Rails.logger.info @import

    ## Products ##
    ## Create values locally ##
    @shop.products.import @import, validate: false, on_duplicate_key_update: Rails.env.development? ? { conflict_target: [:id_product], columns: [:stock, :price] } : [:stock, :price] # required to get it working on Heroku

    ## Remove Import ##
    ## This is required to ensure we keep the db clean ##
    @import.destroy

  end

end

############################################################
############################################################
