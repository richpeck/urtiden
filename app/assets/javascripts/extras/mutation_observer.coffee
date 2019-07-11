#########################################################
#########################################################
##        _____ _                                      ##
##       |  _  | |                                     ##
##       | | | | |__  ___  ___ _ ____   _____ _ __     ##
##       | | | | '_ \/ __|/ _ \ '__\ \ / / _ \ '__|    ##
##       \ \_/ / |_) \__ \  __/ |   \ V /  __/ |       ##
##        \___/|_.__/|___/\___|_|    \_/ \___|_|       ##
##                                                     ##
#########################################################
#########################################################

## Allows us to call Mutation Observers whereever required ##
mutation_observer = (element, callback, config) ->

  # Configuration of the observer
  # subtree: true is the killer thing here -- allows us to keep track of everything under the element
  config =
    attributes: true
    childList: true
    characterData: true
    subtree: true

  # Create an observer instance
  observer = new MutationObserver (mutations) ->
    mutations.forEach (mutation) ->
      callback mutation

  # Pass in the target node, as well as the observer options
  observer.observe element, config

#########################################################
#########################################################
