class Pop.Table

  constructor: (elem_id) ->
    $this = this
    @el = $(elem_id)
    @el.data('pop_table', this)
    @_filters = {}
    @_ajax_data = {}
    Pop.tables ||= []
    Pop.tables.push(this)

  redraw: () ->
    api = @el.dataTable().api()
    if @paging
      api.page.len(@page_length())
      api.draw(true)
    else
      @el.closest(".dataTables_scrollBody").css("height", "#{@scroll_length()}px")

  params: () ->
    p = @el.dataTable().api().ajax.params()
    $.extend(p, @_ajax_data)

  filters_and_search: () ->
    { filters: @params().filters, search: @params().search }

  set_filter: (filter, value) ->
    @_ajax_data.filters ||= {}
    @_ajax_data.filters[filter] = value

  set_filters: (options) ->
    @_ajax_data.filters ||= {}
    @_ajax_data.filters = $.extend(@_ajax_data.filters, options)

  page_length: ->
    table_top = @el.offset().top
    win_height = $(window).height()
    row_height = 35
    head_foot_height = if $(window).width() > 768 then 100 else 120
    len = Math.floor((win_height-table_top-head_foot_height)/row_height)
    len = 15 if len < 10
    len

  scroll_length: ->
    if @el.closest(".dataTables_wrapper").length > 0
      table_top = @el.closest(".dataTables_wrapper").offset().top
    else
      table_top = @el.offset().top
    win_height = $(window).height()
    head_foot_height = if $(window).width() > 768 then 100 else 120
    win_height - table_top - head_foot_height

  tr_click: (url, remote) ->
    if remote
      $.ajax
        url: url
        dataType: 'script'
    else
      window.location.href = url

  ajax_data: (options = {}) ->
    @_ajax_data

  render: (options = {}) ->
    @_ajax_data.authenticity_token = options.authenticity_token
    @paging = options.paging || true
    table_el = @el
    pop_table = this

    for col in options.columns
      if col.link?
        col.render = (data, type, row, meta) ->
          if type == 'display'
            "<a href='#{row.url}' data-remote='#{table_el.data('remote')}'>#{data}</a>"
          else
            data

    table_opts =
      sDom: "tip"
      bStateSave: false
      iDisplayLength: 8
      ajax:
        url: options.url
        type: 'POST'
        data: (d) ->
          $.extend(d, pop_table.ajax_data())
      serverSide: true
      processing: true
      columns: options.columns
      order: options.order
      language:
        url: options.i18n_url
      drawCallback: () ->
        $table = this
        api = $table.api()
        api.$('tr').click () ->
          url = api.row(this).data().url
          remote = $table.data("remote")?
          pop_table.tr_click(url, remote)

    if @paging
      $.extend table_opts,
        pagingType: 'simple'
        pageLength: @page_length()
    else
      $.extend table_opts,
        scroller:
          loadingIndicator: true
        scrollY: pop_table.scroll_length()
        deferRender: true

    table = @el.DataTable(table_opts)

    $(".pop-page-search").submit (e) ->
      e.preventDefault()
      table.search($(this).find("input.form-control").val()).draw()
      return false

    $("a[data-source=pop_table]").on 'click', (ev) ->
      ev.preventDefault()
      table_el = $($(this).data("table"))
      data = table_el.data("pop_table").filters_and_search()
      base_url = $(this).attr('href')
      div = if base_url.indexOf('?') > 0 then "&" else "?"
      url = "#{base_url}#{div}#{$.param(data)}"

      if $(this).attr('target') == '_blank'
        window.open(url)
      else
        window.location.href = url

      return false

    $(".filter-dropdown-menu form").submit (e) ->
      e.stopPropagation()
      e.preventDefault()
      data = $(this).serializeArray()
      filters = {}
      for field in data
        if field.name.match(/^filter_type_*/)
          filter_name = field.name.replace(/^filter_type_/i, '')
          filters[filter_name] ||= {}
          filters[filter_name]['type'] = field.value
        else if field.name.match(/^filter_*/)
          filter_name = field.name.replace(/^filter_/i, '')
          filters[filter_name] ||= {}
          filters[filter_name]['value'] = field.value

      table_ref = $(this).data("table")
      pop_table = if table_ref? then $(table_ref).data("pop_table") else Pop.tables[0]
      pop_table.set_filters(filters)
      pop_table.redraw()
      $(this).closest(".dropdown-menu").siblings(".dropdown-toggle").dropdown("toggle")
      return false

    $(window).on 'resize', () ->
      Pop.tables ||= []
      for table in Pop.tables
        table.redraw()
