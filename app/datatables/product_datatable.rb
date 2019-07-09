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
class ProductDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
       id:   { source: "Product.id", cond: :eq },
       name: { source: "Product.name", cond: :like }
    }
  end

  def data
    records.map do |record|
      {
        id:         record.id,
        first_name: record.name,
        DT_RowId:   record.id # This will automagically set the id attribute on the corresponding <tr> in the datatable
      }
    end
  end

  def get_raw_records
    Product.all
  end

end

############################################################
############################################################
