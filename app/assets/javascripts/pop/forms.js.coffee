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

  $(".form-language-switch a").click (ev) ->
    ev.preventDefault()
    $(this).siblings("a").removeClass("btn-primary")
    $(this).siblings("a").addClass("btn-default")
    $(this).removeClass("btn-default")
    $(this).addClass("btn-primary")

    lang = $(this).attr("href")
    form = $(this).closest("form")
    form.find(".localized-field").hide()
    form.find(".localized-field.#{lang}").show()
    return false

  $('.pop-page-action .daterange').each () ->
    picker = $(this).data('daterangepicker')
    table_ref = $(this).data("table")
    pop_table = if table_ref? then $(table_ref).data("pop_table") else Pop.tables[0]
    column = $(this).data("column")
    if column?
      pop_table.set_filters
        "#{column}":
          type: 'daterange',
          value: "#{picker.startDate.format()}..#{picker.endDate.format()}"

  $('.pop-page-action .daterange').on 'apply.daterangepicker', (ev, picker) ->
    table_ref = $(this).data("table")
    pop_table = if table_ref? then $(table_ref).data("pop_table") else Pop.tables[0]
    column = $(this).data("column")
    if column?
      pop_table.set_filters
        "#{column}":
          type: 'daterange',
          value: "#{picker.startDate.format()}..#{picker.endDate.format()}"
      pop_table.redraw()
