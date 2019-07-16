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
## Because Redis requires succinct information, we need to use
## this to save the CSV rows and then upsert them as required
############################################################
############################################################

## Import ##
## id | type | store_id | id_product | id_brand | id_supplier | ean | name | slug | reference | category | group | brand_name | price | weight | icon | image | img_last_update | retail_price | discount | reference | stock | min_qty | speed_shipping | attributes | synced_at | created_at | updated_at ##
class Import < Product

  #################################
  #################################

    ## FriendlyID ##
    ## https://x.com/products/ipod-8th-gen-video ##
    extend FriendlyId
    friendly_id :name

  #################################
  #################################

    ## Store ##
    ## Ensures we are keeping the data dependent on users being logged in ##
    belongs_to :shop

  #################################
  #################################

    ## Alias Attribute ##
    alias_attribute :title, :name

 #################################
 #################################

     # => Queue Size
     # => Should be in helper but had to move her eto get working with 'whenever' gem
     def self.queue_size
       scheduled = Sidekiq::ScheduledSet.new
       queued    = Sidekiq::Queue.new("sync")
       scheduled.size + queued.size
     end

  #################################
  #################################

    ## Sync ##
    ## This syncs the product with Shopify ##
    ## @product.sync! ##
    def sync!

      ## We already have the @product instance ##
      ## So we need to find the equivalent product on Shopify ##
      shopify_product = ShopifyAPI::Product.find(:all, params: { title: name, limit: 1 }).first

      ## Shopify Map ##
      ## Here we build the data to pass to Shopify ##
      map = {
        title: name,
        vendor: brand_name,
        body_html: attribs,
        product_type: category,
        images:   [{
          src: image
        }],
        variants: [{
          barcode: ean,
          weight:  weight,
          price:   price,
          requires_shipping: true,
          inventory_management: "shopify",
          inventory_policy: "continue",
          sku: reference,
          compare_at_price: retail_price,
          product_id: id_product,
          inventory_quantity: stock,
          weight_unit: "g"
        }]
      }

      ## To do this, we need to look for the unique identifier of the product ##
      if shopify_product

        ## Update Product model ##
        shopify_product.variants.first.price              = map[:variants].first[:price]
        shopify_product.variants.first.compare_at_price   = map[:variants].first[:compare_at_price]
        shopify_product.save

        ## Inventory Quantity has been deprecated, meaning we need to call that API separately ##
        inventory = ShopifyAPI::InventoryLevel.find(:all, params: { inventory_item_ids: shopify_product.variants.first.inventory_item_id }).first
        inventory.set map[:variants].first[:inventory_quantity]

      else
        shopify_product = ShopifyAPI::Product.create(map)
      end

      ## Update Shopify ID ##
      update synced_at: Time.now, id_shopify: shopify_product.id

    end

  #################################
  #################################

end

############################################################
############################################################
