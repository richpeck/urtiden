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

## Products ##
## id | id_product | id_brand | id_supplier | ean | name | reference | category | group | band_name | price | weight | icon | image | img_last_update | retail_price | discount | reference | stock | min_qty | speed_shipping | attributes | synced_at | created_at | updated_at ##
class CreateProducts < ActiveRecord::Migration::Current

  #########################################
  #########################################

    ## Up ##
    ## Creates database table ##
    ## Down automatically assigned by ActiveRecord Concern (FL gem) ##
    def up

      ## Create Table ##
      create_table :products do |t| # => users stored through "associations"

        ## Associations ##
        ## Allows us to determine how product is set up ##
        t.integer :id_product
        t.integer :id_brand
        t.integer :id_supplier

        ## Content ##
        ## Allows us to manage the data etc ##
        t.integer :ean, limit: 8
        t.text    :name
        t.string  :reference
        t.string  :category
        t.string  :group
        t.string  :brand_name
        t.decimal :price, precision: 10, scale: 2
        t.integer :retail_price
        t.decimal :discount, precision: 10, scale: 2
        t.integer :weight
        t.integer :stock
        t.integer :min_qty
        t.integer :speed_shipping
        t.text    :attribs, limit: 4294967296 # => attributes conflicts with ActiveRecord

        ## Images ##
        ## Information about product imagery ##
        t.text     :icon
        t.text     :image
        t.datetime :img_last_update

        ## Timestamps ##
        ## Allows for created_at and updated_at values ##
        t.datetime    :synced_at
        t.datetime    :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
        t.datetime    :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }

        ## Index ##
        ## Gives us unique reference for products ##
        t.index :ean, unique: true

      end

    #########################################
    #########################################

      ## Down ##
      ## Removes DB table on rollback ##
      def down
        drop_table :products, if_exists: true
      end

    #########################################
    #########################################

    end

  #########################################
  #########################################

end

############################################################
############################################################
