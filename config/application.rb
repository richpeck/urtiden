require_relative 'boot'

require 'rails/all'

###############################################################
###############################################################
##       ___              _ _           _   _                ##
##      / _ \            | (_)         | | (_)               ##
##     / /_\ \_ __  _ __ | |_  ___ __ _| |_ _  ___  _ __     ##
##     |  _  | '_ \| '_ \| | |/ __/ _` | __| |/ _ \| '_ \    ##
##     | | | | |_) | |_) | | | (_| (_| | |_| | (_) | | | |   ##
##     \_| |_/ .__/| .__/|_|_|\___\__,_|\__|_|\___/|_| |_|   ##
##           | |   | |                                       ##
##           |_|   |_|                                       ##
###############################################################
###############################################################

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

###############################################################
###############################################################

module Urtiden
  class Application < Rails::Application

    # => Rails 6.0
    # => Allows us to use all the defaults etc
    config.load_defaults 6.0

    # => ExceptionHandler
    config.exception_handler = { dev: true }

    # => Module name
    # => https://stackoverflow.com/questions/28990466/rails-autoloading-fully-capitalized-name-like-api
    ActiveSupport::Inflector.inflections do |inflect|
      inflect.acronym 'API'
    end

  end
end

###############################################################
###############################################################
