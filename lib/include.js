!function($){

  // anytime html is used, look for async includes to load
  $.fn.html = function(html){
    return function(value){
      if (value === undefined) return html.apply(this, arguments);
      html.apply(this, arguments);
      load_async_includes(this);
      return this;
    }
  }($.fn.html);

  // used for async inline replacements
  $.include = function(path, content){
    $('[data-replace_with="'+path+'"]').replaceWith(content);
  }

  $(function(){ load_async_includes(document.body); });

  function load_async_includes(scope){
    $(scope).find('[data-replace_with]').each(function(){
      $.get($(this).data('replace_with'));
    });
  }

}(jQuery);


// just a nice to have
jQuery.fn.loadReplacement = function(url, data, complete){
  var self = this;
  $('<div>').load(url, data, function(){
    self.replaceWith($(this).html());
    if (complete) complete.apply(this, arguments);
  });
}
