############################################################
############################################################
##                 _____                                  ##
##                /  ___|                                 ##
##                \ `--. _   _ _ __   ___                 ##
##                 `--. \ | | | '_ \ / __|                ##
##                /\__/ / |_| | | | | (__                 ##
##                \____/ \__, |_| |_|\___|                ##
##                        __/ |                           ##
##                        |___/                           ##
##                                                        ##
############################################################
############################################################

## Sync All ##
## Because of rate limiting, we need to queue the jobs ##
## This needs to be handled with Sidekik or Redis ##
class SyncJob < ActiveJob::Base
  queue_as :sync
  throttle threshold: 2, period: 5.seconds # => ActiveJobThrottle -- Shopify is rate limited to 40 requests per bucket

  ## Too Many Requests ##
  ## Rescues the update and resubmits to the end of the queue ##
  #rescue_from(StandardError) do
  #  retry_job queue: :sync
  #end

  ## Perform Queue ##
  ## This allows us to send ID's from Resque/Sidekik and process them sequentially ##
  def perform job_id

    # => Sync
    # => Finds specific job and syncs the product
    # => If successful, it posts finished time
    @job = Job.find job_id
    @job.update(finished_at: Time.now) if @job.product.sync!

  end

end

############################################################
############################################################
