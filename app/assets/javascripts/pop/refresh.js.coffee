jQuery ->
  $.fn.refresh = () ->
    return this.each () ->
      $.getScript($(this).data('refresh'))
