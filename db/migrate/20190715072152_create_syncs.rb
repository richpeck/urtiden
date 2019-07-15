############################################
############################################
##          _____                         ##
##         /  ___|                        ##
##         \ `--. _   _ _ __   ___        ##
##          `--. \ | | | '_ \ / __|       ##
##         /\__/ / |_| | | | | (__        ##
##         \____/ \__, |_| |_|\___|       ##
##                 __/ |                  ##
##                |___/                   ##
##                                        ##
############################################
############################################
## Saves sync queue so we can track how many exist
## This not only allows us to see how many products were synced, but gives us the ability to improve performance etc
############################################
############################################

## Sync ##
## id | shop_id | active_job_id | queue_size | created_at | finished_at | updated_at
class CreateSyncs < ActiveRecord::Migration::Current

  #########################################
  #########################################

    ## Up ##
    ## Creates database table ##
    ## Down automatically assigned by ActiveRecord Concern (FL gem) ##
    def up

      ## Create Table ##
      create_table :syncs do |t|
        t.references :shop 
        t.integer    :queue_size
        t.datetime   :finished_at
        t.timestamps
      end

    end

  #########################################
  #########################################

    ## Down ##
    ## Removes DB table on rollback ##
    def down
      drop_table :syncs, if_exists: true
    end

  #########################################
  #########################################

end
