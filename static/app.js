(function() {
'use strict'

var app = window.app = {};


app.HomePage = Backbone.View.extend({

  initialize: function(options) {
    this.$el.html(options.html);
  }

});


app.SongPage = Backbone.View.extend({

  initialize: function() {
    var url = this.model.get('url');
    this.$el.load(url + ' .container > *');
  }

});


app.Router = Backbone.Router.extend({

  initialize: function(options) {
    this.homepage_html = options.homepage_html;
    this.song_col = options.song_col;
  },

  routes: {
    '': 'home',
    'song/:slug': 'song'
  },

  home: function() {
    this.show(new app.HomePage({
      html: this.homepage_html,
      collection: this.song_col
    }));
  },

  song: function(slug) {
    this.show(new app.SongPage({
      model: this.song_col.findWhere({slug: slug})
    }));
  },

  show: function(view) {
    $(window).scrollTop(0);
    if(this.view) {
      this.view.remove();
    }
    this.view = view;
    this.view.$el.appendTo($('.content'));
  }

});


app.initialize = function() {
  $('body').addClass('js-loading');
  $(document).ready(app.on_document_ready);
};

app.normalize = function(text) {
  return text
      .toLowerCase()
      .replace(/[ăâ]/g, 'a')
      .replace(/î/g, 'i')
      .replace(/ș/g, 's')
      .replace(/ț/g, 't');
};

app.cmp = function(a, b) {
  return app.normalize($(a).text()) < app.normalize($(b).text()) ? -1 : 1;
};

app.extract_song = function(li) {
  var $song_link = $('.song-link', li);
  var url = $song_link.attr('href');
  var slug = url.match(/([^/]+)\.html$/)[1];
  $song_link.attr('href', '#song/' + slug);
  return new Backbone.Model({
    title: $song_link.text(),
    url: url,
    slug: slug
  });
};

app.on_document_ready = function() {
  var song_col = new Backbone.Collection;

  var $song_ul = $('.song-list');
  var song_list = $song_ul.find('> li').remove().toArray().sort(app.cmp);
  song_list.forEach(function(item) {
    var song = app.extract_song(item);
    song_col.add(song);
    $song_ul.append(item);
  });

  $('body').removeClass('js-loading');
  $('.footer').append("; cântece: " + song_col.length);

  app.router = new app.Router({
    homepage_html: $('.homepage').remove().html(),
    song_col: song_col
  });

  Backbone.history.start({pushState: false});
};

})();
