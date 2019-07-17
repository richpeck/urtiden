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
## id | shop_id | product_id | active_job_id | finished_at | created_at | updated_at
class Job < ApplicationRecord

  ###############################
  ###############################

    ## Associations ##
    belongs_to :shop
    belongs_to :product

  ###############################
  ###############################

    ## Scopes ##
    ## Allows us to call @shop.jobs.unfinished ##
    scope :unfinished, -> { where(finished_at: nil) }

  ###############################
  ###############################

    ## After Create ##
    ## Adds the newly created job record to ActiveJob Queue ##
    after_create do

      ## Add the job to the queue ##
      job = SyncJob.perform_later self[:id]

      ## Record its active_job_id here ##
      update active_job_id: job

    end

  ###############################
  ###############################

    ## Before Destroy ##
    ## Get rid of the Sidekiq queue member for this ##
    before_destroy do
      puts "Delete Queue"
    end

  ###############################
  ###############################

end

############################################
############################################
