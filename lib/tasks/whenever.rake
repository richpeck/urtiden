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
## This runs the whenever gem each time the assets are precompiled ##
## You may say it's overkill, but it's required to get the cron to run ##
############################################
############################################

## New ##
## Updates "whenever" to include any updates from ./config/schedule.rb ##
Rake::Task["assets:precompile"].enhance do
  !Rails.env.production? ? system("whenever") : system("whenever --update-crontab")
end

############################################
############################################
