############################################
############################################
##           ___       _                  ##
##          |_  |     | |                 ##
##            | | ___ | |__  ___          ##
##            | |/ _ \| '_ \/ __|         ##
##        /\__/ / (_) | |_) \__ \         ##
##        \____/ \___/|_.__/|___/         ##
##                                        ##
############################################
############################################
## Saves each job as an ActiveRecord object
## The reason for this is to help us keep track
############################################
############################################

## Job ##
## id | sync_id | product_id | active_job_id | finished_at | created_at | updated_at
class CreateJobs < ActiveRecord::Migration::Current
  #########################################
  #########################################

    ## Up ##
    ## Creates database table ##
    ## Down automatically assigned by ActiveRecord Concern (FL gem) ##
    def up

      ## Create Table ##
      create_table :jobs do |t|
        t.references :sync          # => belongs to "syncs" model
        t.references :product       # => belongs to "product" model (acts as has_many though relation)
        t.string     :active_job_id # => required for each activejob instance
        t.datetime   :finished_at   # => gives us the ability to record the completion of the task
        t.timestamps
      end

    end

  #########################################
  #########################################

    ## Down ##
    ## Removes DB table on rollback ##
    def down
      drop_table :jobs, if_exists: true
    end

  #########################################
  #########################################

end

############################################
############################################
