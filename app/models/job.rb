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
class Job < ApplicationRecord

  ## Associations ##
  belongs_to :sync
  belongs_to :product

  ## Counter Cache ##
  ## Uses "counter_culture" gem ##
  ## This is used to keep track of how many jobs have been completed in the sync model ##
  counter_culture :sync#, column_name: proc {|model| model.finished_at ? 'jobs_counter' : nil }

  ## After Create ##
  ## Adds the newly created job record to ActiveJob Queue ##
  after_create do

    ## Add the job to the queue ##
    job = SyncJob.perform_later self[:id]

    ## Record its active_job_id here ##
    update active_job_id: job

  end

end

############################################
############################################
