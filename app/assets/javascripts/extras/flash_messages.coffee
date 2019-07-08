# Flash Messages

eventName = if typeof Turbolinks != 'undefined' then 'turbolinks:load' else 'DOMContentLoaded'
if !document.documentElement.hasAttribute('data-turbolinks-preview')
  document.addEventListener eventName, ->
    flashData = JSON.parse(document.getElementById('shopify-app-flash').dataset.flash)
    if flashData.notice
      ShopifyApp.flashNotice flashData.notice
    if flashData.error
      ShopifyApp.flashError flashData.error
    document.removeEventListener eventName, flash
    return
