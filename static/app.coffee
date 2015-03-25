---
---
'use strict'

app = window.app = {}


class app.HomePage extends Backbone.View

  initialize: (options) ->
    @$el.html(options.html)
    @search = new app.Search(
      el: @$el.find('#search')
      index: options.index
      collection: @collection
    )


class app.SongPage extends Backbone.View

  initialize: ->
    @$el.html(@model.get('content'))


class app.Router extends Backbone.Router

  initialize: (options) ->
    @homepage_html = options.homepage_html
    @song_col = options.song_col
    @index = options.index

  routes:
    '': 'home'
    'song/:slug': 'song'

  home: ->
    @show(new app.HomePage(
      html: @homepage_html
      collection: @song_col
      index: @index
    ))

  song: (slug) ->
    @show(new app.SongPage(model: @song_col.findWhere(slug: slug)))

  show: (view) ->
    $(window).scrollTop(0)
    if @view
      @view.remove()
    @view = view
    @view.$el.appendTo($('.content'))


class app.Index

  constructor: ->
    @lunr = lunr ->
      @pipeline.add (token, tokenIndex, tokens) ->
        token
          .replace(/ș/g, 's')
          .replace(/ş/g, 's')
          .replace(/ț/g, 't')
          .replace(/ţ/g, 't')
          .replace(/ă/g, 'a')
          .replace(/â/g, 'a')
          .replace(/î/g, 'i')
      @field('title', boost: 10)
      @field('text')
      @ref('slug')

  add: (song) ->
    data = song.get('content')
    $d = $('<div>').append(data).find('.container')
    $d.find('script').remove()
    $d.find('.song-home-link').remove()
    doc = _.extend(song.toJSON(), text: $d.text())
    @lunr.add(doc)

  search: (query) -> @lunr.search(query)


class app.Search extends Backbone.View

  events:
    'submit': (evt) -> evt.preventDefault()
    'change': -> @update()
    'keyup': -> @update()
    'click #search-clear': (evt) ->
      input = @$el.find('input')
      input.val('')
      @update()
      input.focus()

  initialize: (options) ->
    @index = options.index
    @song_col = options.song_col

  update: ->
    query = @$el.find('input').val()

    unless query
      $('li').show()
      return

    $('li').hide()
    for result in @index.search(query)
      slug = result.ref
      $('li[data-slug="' + slug + '"]').show()


app.initialize = ->
  $('body').addClass('js-loading')
  $(document).ready(app.on_document_ready)

app.normalize = (text) ->
  return text
      .toLowerCase()
      .replace(/[ăâ]/g, 'a')
      .replace(/î/g, 'i')
      .replace(/ș/g, 's')
      .replace(/ț/g, 't')

app.cmp = (a, b) ->
  if app.normalize($(a).text()) < app.normalize($(b).text())
    return -1
  else
    return 1

app.extract_song = (li) ->
  $song_link = $('.song-link', li)
  slug = $song_link.attr('href').match(/([^/]+)\.html$/)[1]
  $(li).attr('data-slug', slug)
  $song_link.attr('href', '#song/' + slug)
  return new Backbone.Model(
    title: $song_link.text()
    slug: slug
    content: $('.song-content', li).remove().html()
  )

app.on_document_ready = ->
  app.song_col = new Backbone.Collection()
  app.index = new app.Index()

  $song_ul = $('.song-list')
  for item in $song_ul.find('> li').remove().toArray().sort(app.cmp)
    song = app.extract_song(item)
    app.song_col.add(song)
    $song_ul.append(item)
    app.index.add(song)

  $('body').removeClass('js-loading')
  $('.footer').append("; cântece: " + app.song_col.length)

  app.router = new app.Router(
    homepage_html: $('.homepage').remove().html()
    song_col: app.song_col
    index: app.index
  )

  Backbone.history.start(pushState: false)
