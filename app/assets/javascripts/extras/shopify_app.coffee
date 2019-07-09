# Shopify
document.addEventListener 'DOMContentLoaded', ->
  data = document.getElementById('shopify-app-init').dataset
  ShopifyApp.init
    apiKey: data.apiKey
    shopOrigin: data.shopOrigin
    debug: data.debug == 'true'
    forceRedirect: false
  return
