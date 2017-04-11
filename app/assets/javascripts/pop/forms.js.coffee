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
      template: 'dropdown'
      showSeconds: false
      defaultTime: ''
      showMeridian: false
      minuteStep: 5
      secondStep: 5

    $this.timepicker(opts)

    if $n.is('.input-group-addon') && $n.has('a')
      $n.on 'click', (ev) ->
        ev.preventDefault()
        $this.timepicker('showWidget')
        return false

    if $p.is('.input-group-addon') && $p.has('a')
      $n.on 'click', (ev) ->
        ev.preventDefault()
        $this.timepicker('showWidget')
        return false



  $("select.pop-select2").each (i, el) ->
    $this = $(el)
    unless $this.data("pop-on")?
      $this.data("pop-on", true)

    opts = $this.data()
    $this.select2(opts)

  $("input[type='checkbox']").each (i, el) ->
    sel = $(el).data("toggle")
    if sel
      if $(el).is(':checked')
        $(sel).show()
      else
        $(sel).hide()

      $(el).click (ev) ->
        $(sel).toggle()
