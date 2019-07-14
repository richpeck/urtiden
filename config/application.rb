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

    ##########################################
    ##########################################

      # => Rails 6.0
      # => Allows us to use all the defaults etc
      config.load_defaults 6.0

      # => Locale
      # => https://stackoverflow.com/questions/6118779/how-to-change-default-timezone-for-active-record-in-rails
      config.time_zone = "London"
      config.active_record.default_timezone = :local

      # => DataTables
      # => https://github.com/jbox-web/ajax-datatables-rails#configuration
      AjaxDatatablesRails.configure do |config|
        config.db_adapter = Rails.env.staging? ? :mysql2 : Rails.configuration.database_configuration[Rails.env]['adapter'].to_sym # => Need to fix this -- Heroku eager loads everything
      end

      # => Assets
      # => Allows us to use helper methods inside JS
      # => Requires sprockets-helpers gem (https://stackoverflow.com/a/37092476/1143732)
      # => https://stackoverflow.com/questions/7451517/using-a-rails-helper-method-within-a-javascript-asset
      Sprockets::Context.send :include, Rails.application.routes.url_helpers
      Sprockets::Context.send :include, ActionView::Helpers

    ##########################################
    ##########################################

      # => ActiveJob
      # => Allows us to manage the queue for the "sync all" method
      config.active_job.queue_adapter = :sidekiq

      # => ActiveJob Throttle
      # => Allows us to manage the underlying rate limiting of API requests
      ActiveJob::TrafficControl.client = Redis.new( host: Rails.application.credentials.dig(Rails.env.to_sym, :redis, :host), port: Rails.application.credentials.dig(Rails.env.to_sym, :redis, :port), password: Rails.application.credentials.dig(Rails.env.to_sym, :redis, :pass))

      # => Redis
      # => Hosted at RedisLabs
      # => Both settings required to get it working
      Sidekiq.configure_client do |config|
        config.redis = { url: "redis://#{Rails.application.credentials.dig(Rails.env.to_sym, :redis, :host)}:#{Rails.application.credentials.dig(Rails.env.to_sym, :redis, :port)}", password:  Rails.application.credentials.dig(Rails.env.to_sym, :redis, :pass) }
      end

      # => Server
      # => Allows us to connect to the right server
      Sidekiq.configure_server do |config|
        config.redis = { url: "redis://#{Rails.application.credentials.dig(Rails.env.to_sym, :redis, :host)}:#{Rails.application.credentials.dig(Rails.env.to_sym, :redis, :port)}", password:  Rails.application.credentials.dig(Rails.env.to_sym, :redis, :pass) }
      end

    ##########################################
    ##########################################

  end
end

###############################################################
###############################################################
