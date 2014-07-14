---
---
'use strict'

app = window.app = {}


app.initialize = ->
  $('body').addClass 'js-loading'
  $(document).ready app.on_document_ready

app.normalize = (text) ->
  return text
      .toLowerCase()
      .replace(/[ăâ]/g, 'a')
      .replace(/î/g, 'i')
      .replace(/ș/g, 's')
      .replace(/ț/g, 't')

app.cmp = (a, b) ->
  if app.normalize($(a).text()) < app.normalize($(b).text())
    -1
  else
    1

app.on_document_ready = ->
  song_items = $('.song-list > li').remove().toArray().sort app.cmp
  $('.song-list').append song_items
  $('body').removeClass 'js-loading'
  $('.footer').append "; cântece: " + song_items.length
