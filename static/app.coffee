---
---
'use strict'

app = window.app = {}


class app.HomePage extends Backbone.View

  initialize: (options) ->
    @$el.html options.html


class app.SongPage extends Backbone.View

  initialize: ->
    url = @model.get 'url'
    @$el.load url + ' .container > *'


class app.Router extends Backbone.Router

  initialize: (options) ->
    @homepage_html = options.homepage_html
    @song_col = options.song_col

  routes:
    '': 'home'
    'song/:slug': 'song'

  home: ->
    @show new app.HomePage
      html: @homepage_html
      collection: @song_col

  song: (slug) ->
    @show new app.SongPage
      model: @song_col.findWhere slug: slug

  show: (view) ->
    if @view
      @view.remove()
    @view = view
    @view.$el.appendTo $('.content')


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

app.extract_song = (li) ->
  $song_link = $('.song-link', li)
  url = $song_link.attr('href')
  slug = url.match(/([^/]+)\.html$/)[1]
  $song_link.attr 'href', '#song/' + slug
  new Backbone.Model
    title: $song_link.text()
    url: url
    slug: slug

app.on_document_ready = ->
  song_col = new Backbone.Collection

  $song_ul = $('.song-list')
  for item in $song_ul.find('> li').remove().toArray().sort app.cmp
    song = app.extract_song item
    song_col.add song
    $song_ul.append item

  $('body').removeClass 'js-loading'
  $('.footer').append "; cântece: " + song_col.length

  app.router = new app.Router
    homepage_html: $('.homepage').remove().html()
    song_col: song_col

  Backbone.history.start pushState: false
