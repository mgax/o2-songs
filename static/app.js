(function() {
'use strict';

var app = window.app = {};


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

app.on_document_ready = function() {
  var song_items = $('.song-list > li').remove().toArray().sort(app.cmp);
  $('.song-list').append(song_items);
  $('body').removeClass('js-loading');
  $('.footer').append("; cântece: " + song_items.length);
};


})();
