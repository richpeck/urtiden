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

  ## Initialize ##
  def initialize(params, opts = {})
   @shop = opts[:shop]
   @view = opts[:view_context]
   super
  end

  ## Delegators ##
  def_delegators :@view, :link_to, :image_tag

  ## Column Search Lookup ##
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
       id:    { source: "Product.id", cond: :eq },
       icon:  { source: "Product.icon", cond: :eq },
       name:  { source: "Product.name", cond: :like },
       price: { source: "Produt.price", cond: :eq }
    }
  end

  ## Data ##
  ## This is what gets passed back to the script ##
  def data
    records.map do |record|
      {
        id:         record.id,
        icon:       image_tag(record.icon),
        name:       record.name,
        price:      record.price,
        DT_RowId:   record.id # This will automagically set the id attribute on the corresponding <tr> in the datatable
      }
    end
  end

  ## Records ##
  def get_raw_records
    Product.all
  end

end

############################################################
############################################################
