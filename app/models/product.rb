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
## All of the import mechanisms need to be handled at controller level
## Allows us to keep system up to date & manage which ones will be synced over other API's
############################################################
############################################################

## Product ##
## id | id_product | id_brand | id_supplier | ean | name | slug | reference | category | group | band_name | price | weight | icon | image | img_last_update | retail_price | discount | reference | stock | min_qty | speed_shipping | attributes | synced_at | created_at | updated_at ##
class Product < ApplicationRecord

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
    belongs_to :store

  #################################
  #################################

    ## Alias Attribute ##
    alias_attribute :title, :name

  #################################
  #################################

    ## Sync ##
    ## This syncs the product with Shopify ##
    ## @product.sync ##
    def sync

      ## We already have the @product instance ##
      ## So we need to find the equivalent product on Shopify ##

      ## To do this, we need to look for the unique identifier of the product ##
      ShopifyAPI::Product.find title: self[:name]

    end

  #################################
  #################################

end

############################################################
############################################################
