#########################################################
#########################################################
##   ___              _ _           _   _              ##
##  / _ \            | (_)         | | (_)             ##
## / /_\ \_ __  _ __ | |_  ___ __ _| |_ _  ___  _ __   ##
## |  _  | '_ \| '_ \| | |/ __/ _` | __| |/ _ \| '_ \  ##
## | | | | |_) | |_) | | | (_| (_| | |_| | (_) | | | | ##
## \_| |_/ .__/| .__/|_|_|\___\__,_|\__|_|\___/|_| |_| ##
##       | |   | |                                     ##
##       |_|   |_|                                     ##
##                                                     ##
#########################################################
#########################################################

## Libs ##
#= require 'jquery'
#= require 'jquery_ujs'
#= require 'turbolinks'
#= require 'bootstrap'

#########################################################
#########################################################

## Extras ##
#= require_tree ./extras

#########################################################
#########################################################

## DataTables ##
## Allows us to showcase the products for a store on the index page ##
$(document).ready ->
  $('#products').dataTable
    processing: true
    serverSide: true
    autoWidth:  true
    responsive: true
    select:     true # requires "select" plugin
    ajax:
      url: $('#products').data('source')
    pagingType: 'simple_numbers'
    columnDefs: [
      {
        targets: ['id', 'icon', 'sync'],
        createdCell:  (td, cellData, rowData, row, col) ->
           $(td).addClass('center');
      }
    ]
    columns: [
      {data: 'id',          name: 'id' }
      {data: 'icon',        name: 'thumbnail' }
      {data: 'name',        name: 'name' }
      {data: 'price',       name: 'price' }
      {data: 'stock',       name: 'stock' }
      {data: 'synced_at',   name: 'synced_at' }
      {data: 'created_at',  name: 'created_at' }
      {data: 'updated_at',  name: 'updated_at' }
      {data: 'sync' }
    ]
    #dom: 'Bfrtip'
    buttons: [
      'selectAll',
      'selectNone'
    ]
    language:
      emptyTable: "No data available in table. <b>Please <a href='/import'>Import</a><b/>."
      processing: "Processing"
      buttons: {
        selectAll: "Select all items"
        selectNone: "Select none"
      }

#########################################################
#########################################################
