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

## Datatable Class ##
## Allows us to determine exactly what appears in the datatable here ##
## https://github.com/jbox-web/ajax-datatables-rails#using-view-helpers ##
class ProductDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  ## Initialize ##
  def initialize(params, opts = {})
   @shop = opts[:shop]
   @view = opts[:view_context]
   super
  end

  ## Delegators ##
  def_delegators :@view, :link_to, :image_tag, :number_to_currency, :link_to, :product_path, :content_tag, :sync_product_path

  ## Column Search Lookup ##
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
       id:          { source: "Product.id_product", cond: :like },
       icon:        { source: "Product.icon", cond: :eq },
       brand:       { source: "Product.brand_name", cond: :like},
       name:        { source: "Product.name", cond: :like },
       price:       { source: "Product.price", cond: :eq },
       stock:       { source: "Product.stock", cond: :eq },
       synced_at:   { source: "Product.synced_at", cond: :eq },
       created_at:  { source: "Product.created_at", cond: :eq },
       updated_at:  { source: "Product.updated_at", cond: :eq },
       sync:        { source: "Product.name", cond: :eq }
    }
  end

  ## Data ##
  ## This is what gets passed back to the script ##
  def data
    records.map do |record|
      {
        id:         record.id_product,
        icon:       link_to(image_tag(record.icon), product_path(record)),
        brand:      record.brand_name,
        name:       record.name,
        price:      number_to_currency(record.price, unit: "€"),
        stock:      record.stock,
        synced_at:  record.synced_at.try(:strftime, '%b %d %Y (%H:%M:%S %Z)') || "N/A",
        created_at: record.created_at.strftime('%b %d %Y (%H:%M:%S %Z)'),
        updated_at: record.updated_at.strftime('%b %d %Y (%H:%M:%S %Z)'),
        sync:       content_tag(:div, link_to("✔️", sync_product_path(record), method: :put, class: "sync", remote: true, title: "Sync", data: { confirm: "Sync?", type: :json }) + link_to("⛔", product_path(record), method: :delete, title: "Delete", data: { confirm: "Really Delete?" }) ),
        DT_RowId:   record.id # This will automagically set the id attribute on the corresponding <tr> in the datatable
      }
    end
  end

  ## Records ##
  ## Where the records come from ##
  def get_raw_records
    @shop.products
  end

end

############################################################
############################################################
