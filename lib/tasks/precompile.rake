##############################################
##############################################
##           _____ _ _                      ##
##          |  ___(_) |                     ##
##          | |_   _| | ___  ___            ##
##          |  _| | | |/ _ \/ __|           ##
##          | |   | | |  __/\__ \           ##
##          \_|   |_|_|\___||___/           ##
##                                          ##
##############################################
##############################################

## Libs ##
require 'fileutils'

## This to add / remove files from the precompilation processs ##
## For now, it's aimed at the "favicon" and "sitemap" files    ##
## Others can be added as required!                            ##

##############################################
##############################################

## Extensions ##
## These run after you fire another task ##
task "assets:precompile" => %w(sitemap:refresh) if Object.const_defined?("SitemapGenerator") # => Sitemap Generator

##############################################
##############################################

## Declarations ##
create  = [ { from: ["app", "assets", "images", "favicon.ico"], to: ["public", "favicon.ico"] } ]
destroy = ["favicon.ico", "sitemap.xml.gz", "sitemap1.xml.gz", "sitemap2.xml.gz"]

##############################################
##############################################

## New ##
Rake::Task["assets:precompile"].enhance do

  ## Create ##
  ## Takes the "create" variable and moves files from one location to another ##
  ## http://blog.honeybadger.io/ruby-splat-array-manipulation-destructuring#using-an-array-to-pass-multiple-arguments ##
  create.each do |item|

    ## Definitions ##
    ## Define the variables to use ##
    asset = Rails.root.join *item[:from]
    destination = Rails.root.join *item[:to]

    ## Action ##
    ## Check if file exists / is same as present ##
    if File.exist?(asset) && (!File.exist?(destination) || File.mtime(asset) > File.mtime(destination))
      FileUtils.cp asset, destination, verbose: true, preserve: true
    end

  end
end

##############################################
##############################################

## Destroy ##
Rake::Task["assets:clobber"].enhance do

  ## Destroy ##
  ## Takes "destroy" variable and removes files it contains ##
  destroy.each do |file|
    file = Rails.root.join("public", file)
    FileUtils.rm file, verbose: true if File.exist? file
  end
end

##############################################
##############################################
