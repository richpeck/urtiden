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
  def sync_all
    Rails.logger.info ShopifyAPI::Product.find(:all, params: { title: "Beauty Night Audrey" })

    redirect_to action: :index
  end

  ###############################################
  ###############################################

  ## Sync ##
  ## Syncs product ##
  def sync
    @product = @products.find params[:id]
    @product.sync # => model method

    respond_to do |format|
      format.js   { render json: @product.to_json }
      format.html { redirect_to action: :index }
    end
  end

  ###############################################
  ###############################################

  ## Import ##
  ## This imports all products from the API ##
  ## It's a simple method which basically connects to the API endpoint (with credentials) and then populates our DB ##
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
    products = []

    ## Cycle through each of the newly created records ##
    csv.uniq.take(1000).each do |product|
      products << @products.new(product)
    end

    ## Products ##
    ## Create values locally ##
    @products.import products, validate: false, on_duplicate_key_update: Rails.env.development? ? { conflict_target: [:id_product], columns: [:stock, :price] } : [:stock, :price] # required to get it working on Heroku

    ## Action ##
    ## Redirect back to index ##
    respond_to do |format|
      format.html {
        flash[:notice] = pluralize(products.count, "Products") + " Imported"
        redirect_to action: :index
      }
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
