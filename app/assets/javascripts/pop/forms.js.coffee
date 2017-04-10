Pop.init_forms = (options = {}) ->

  $(".datepicker").each (i, el) ->
    $this = $(el)
    unless $this.data("pop-on")?
      $this.data("pop-on", true)
      $n = $this.next()
      $p = $this.prev()
      opts =
        language: 'es'

      $this.datepicker(opts)

      if $n.is('.input-group-addon') && $n.has('a')
        $n.on 'click', (ev) ->
          ev.preventDefault()
          $this.datepicker('show')
          return false

      if $p.is('.input-group-addon') && $p.has('a')
        $n.on 'click', (ev) ->
          ev.preventDefault()
          $this.datepicker('show')
          return false

  $(".timepicker").each (i, el) ->
    $this = $(el)
    $n = $this.next()
    $p = $this.prev()
    opts =
      template: false
      showSeconds: false
      defaultTime: 'current'
      showMeridian: false
      minuteStep: 15
      secondStep: 15

    $this.timepicker(opts)

    if $n.is('.input-group-addon') && $n.has('a')
      $n.on 'click', (ev) ->
        $this.timepicker('showWidget')

    if $p.is('.input-group-addon') && $p.has('a')
      $n.on 'click', (ev) ->
        $this.timepicker('showWidget')
        


  $("select.pop-select2").each (i, el) ->
    $this = $(el)
    unless $this.data("pop-on")?
      $this.data("pop-on", true)
      $this.select2($this.data())

  $("input[type='checkbox']").each (i, el) ->
    sel = $(el).data("toggle")
    if sel
      if $(el).is(':checked')
        $(sel).show()
      else
        $(sel).hide()

      $(el).click (ev) ->
        $(sel).toggle()
