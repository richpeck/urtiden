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
require 'csv' # => Allows us to read the CSV

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

    #Product.update_all stock: 10000
    #product = Product.first
    #product.update name: "test"

    ## The way it works is two-fold ##
    ## Firstly, the user connects to Shopify - this is done via the app ##
    ## This is done because it's the best way to get it working ##
    ## - ##
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

    # => Define Job
    # => This has to be done randomly because ActiveJob doesn't give any Job ID
    job = Meta::Sync.create ref: SecureRandom.uuid, val: "Started: #{DateTime.now}"

    # => Cycle
    # => Adds the various id's to the queue and then the sidekiq system goes through them
    self.ids.each do |product|
      SyncJob.perform_later product, job.ref
    end

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
    @products = @shop.import # => Overrides ActiveRecord::Import on this model

    ## Action ##
    respond_to do |format|
      format.html { flash[:notice] = pluralize(@products.count, "Products") + " Imported"; redirect_to action: :index }
      format.js { render json: @products.to_json }
    end

  end

  ###############################################
  ###############################################

  private

  ## Params ##
  def product_params
    params.require(:product).permit(:name)
  end

  ###############################################
  ###############################################

end

############################################################
############################################################
