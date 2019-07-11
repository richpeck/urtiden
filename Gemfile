###########################################
###########################################
##   _____                 __ _ _        ##
##  |  __ \               / _(_) |       ##
##  | |  \/ ___ _ __ ___ | |_ _| | ___   ##
##  | | __ / _ \ '_ ` _ \|  _| | |/ _ \  ##
##  | |_\ \  __/ | | | | | | | | |  __/  ##
##  \_____/\___|_| |_| |_|_| |_|_|\___|  ##
##                                       ##
###########################################
###########################################

# => Sources
source 'https://rubygems.org'
source 'https://rails-assets.org' # => (Heroku) https://github.com/tenex/rails-assets/issues/325

########################################
########################################

# => Ruby
# => https://github.com/cantino/huginn/blob/master/Gemfile#L4
ruby [RUBY_VERSION, '2.6.3'].min

# => Rails
gem 'rails', '~> 6.0.0.rc1'

# => Server
# => Default dev development for Rails 5 but still needs the gem....
# => https://richonrails.com/articles/the-rails-5-0-default-files
gem 'puma', groups: [:development, :staging] # => Production will use phusion with nginx

# => DB
# => https://github.com/rrrene/projestimate/blob/master/Gemfile#L11
gem 'sqlite3', group: :development
gem 'mysql2',  groups: [:staging,:production]

########################################
########################################

# Platform Specific
# http://bundler.io/v1.3/man/gemfile.5.html#PLATFORMS-platforms-

# => Win
gem 'tzinfo-data' if Gem.win_platform? # => TZInfo For Windows

# => Not Windows
unless Gem.win_platform?
  gem 'execjs'       		# => http://stackoverflow.com/a/6283074/1143732
  gem 'mini_racer' 		  # => http://stackoverflow.com/a/6283074/1143732
end

########################################
########################################

####################
#     Frontend     #
####################

## HAML & SASS ##
gem 'sass-rails' # => Supercedes sass-rails // https://github.com/rails/sass-rails/pull/424
gem 'uglifier', '~> 3.0'
gem 'haml', '~> 5.0', '>= 5.0.3'

## JS ##
gem 'coffee-rails', '~> 4.2', '>= 4.2.1'
gem 'jquery-rails'
gem 'turbolinks', '~> 5.0'
gem 'jbuilder', '~> 2.0'

########################################
########################################

####################
#     Backend      #
####################

## General ##
## Used to provide general backend support for Rails apps ##
gem 'shopify_app', '~> 11.0'                          # => Allows us to integrate directly into Shopify's API with the help of oAuth
gem 'exception_handler', '~> 0.8.0.0'                 # => Without FL gem, need to add this specifically
gem 'bootsnap', '~> 1.3', '>= 1.3.2', require: false  # => Boot caching (introduced in 5.2.x)
gem 'friendly_id', github: 'norman/friendly_id'       # => Fixes for Rails 6.0.0.rc1
gem 'faraday', '~> 0.15.4'                            # => Faraday (used for API connection)

## Data Management ##
## Gives us the ability to manage the products within the store ##
gem 'activerecord-import', '~> 1.0', '>= 1.0.1'       # => Whilst upsert_all in beta // https://github.com/zdennis/activerecord-import
gem 'ajax-datatables-rails', '~> 1.0'                 # => Allows us to show product data tables on the screen
gem 'jquery-datatables', '~> 1.10', '>= 1.10.19.1'    # => Required for Ajax Datatables to get working

## Assets ##
gem 'rails-assets-bootstrap'                          # => Bootstrap (required for DataTables to look good)
gem 'rails-assets-datatables-select'                  # => Plugin for JQuery DataTables
gem 'sprockets-helpers', '~> 1.2', '>= 1.2.1'         # => Required to get asset paths available in Javascript

########################################
########################################
