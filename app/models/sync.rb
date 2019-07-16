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
############################################
############################################

## Sync ##
## id | shop_id | jobs_count | finished_at | created_at | updated_at
class Sync < ApplicationRecord

  ## Associations ##
  belongs_to :shop # => has counter_cache which looks for "finished_at" condition w/ counter_culture gem

  ## Jobs ##
  ## This allows us to store each individual job in a separate table ##
  ## The goal is to record each queue's jobs in the table and update it as required ##
  has_many :jobs, dependent: :delete_all
  has_many :products, through: :jobs

end

############################################
############################################
