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

## Libs ##
require 'csv'         # => Allows us to read the CSV
require 'sidekiq/api' # => Allows us to check if queue is running

############################################################
############################################################

# frozen_string_literal: true

## Products Controller ##
## Allows us to manage imported products with Shopify ##
class ProductsController < ShopifyApp::AuthenticatedController
  include ActionView::Helpers::TextHelper # => Required for pluralize

  ############################################################
  ############################################################

  ## Before Action ##
  before_action Proc.new { @shop = Shop.find_by shopify_domain: shop_session.domain }
  before_action Proc.new { @products = @shop.products }

  ############################################################
  ############################################################

  ## Layout ##
  layout Proc.new { |c| false if c.request.xhr? }

  ############################################################
  ############################################################

  ## Index ##
  ## This is the main page they see when they want to match products with their store ##
  def index

    ## The way it works is two-fold ##
    ## Firstly, the user connects to Shopify - this is done via the app ##
    ## This is done because it's the best way to get it working ##

    ## After this, we are able to populate the dashboard with the user's imported products etc ##
    ## Allowing us to sync them together as required ##
    @products ||= ShopifyAPI::Product.find(:all, params: { limit: 10 })

    ## Response ##
    ## This is used by the ajax datatables gem ##
    respond_to do |format|
      format.html
      format.json { render json: ProductDatatable.new(params, shop: @shop, view_context: view_context) } # => https://github.com/jbox-web/ajax-datatables-rails#4-setup-the-controller-action
    end

  end

  ## Cancel All ##
  ## Stops current queue + removes it completely ##
   

  ###############################################
  ###############################################

  ## Destroy All ##
  ## Removes all products per shop ##
  def destroy_all
    @products.delete_all

    flash[:notice] = pluralize(@products.count, "Products") + " Destroyed"
    redirect_to action: :index
  end

  ###############################################
  ###############################################

  ## Destroy ##
  ## Removes single product ##
  def destroy
    @product = @products.find params[:id]
    @product.destroy

    flash[:notice] = "#{@product.name} Destroyed"
    redirect_to action: :index
  end

  ###############################################
  ###############################################

  ## Sync All ##
  ## Syncs every product in the db ##
  ## This should only fire if there is a job present ##
  def sync_all

    ## Validation ##
    ## In case the "sync_all" button is pressed ##
    if (@shop.queues.where(finished_at: nil).pluck(:queue_size).first || 0) > 0

      ## Don't do anything & just return a notice ##
      flash[:notice] = "Queue already present"

    else

      # => Define Job
      # => This has to be done randomly because ActiveJob doesn't give a Job ID
      @job = @shop.queues.create

      # => Cycle
      # => Adds the various id's to the queue and then the sidekiq system goes through them
      @products.pluck(:id_product).each do |product|
        #SyncJob.perform_later @job.id, product
      end

      # => Update Queue Size
      @job.update_attributes queue_size: @products.count

    end

    # => Redirect back to index
    redirect_to action: :index
  end

  ###############################################
  ###############################################

  ## Sync ##
  ## Syncs product ##
  def sync
    @product = @products.find params[:id]
    @product.sync! # => model method

    respond_to do |format|
      format.html { redirect_to action: :index }
      format.js   { render json: @product.to_json }
    end
  end

  ###############################################
  ###############################################

  ## Import ##
  ## This imports all products from the API ##
  ## It's a simple method which basically connects to the API endpoint (with credentials) and then populates our DB ##
  def import

    ## Import ##
    ## Runs from Shop model & returns list of newly imported products ##
    @products = @shop.import # => Overrides ActiveRecord::Import on this model (required to be used in whenever gem)

    ## Action ##
    respond_to do |format|
      format.js   { render json: @products.to_json }
      format.html { flash[:notice] = pluralize(@products.count, "Products") + " Imported"; redirect_to action: :index }
    end

  end

  ###############################################
  ###############################################

end

############################################################
############################################################
