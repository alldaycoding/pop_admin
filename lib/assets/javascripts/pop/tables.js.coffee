class Pop.Table

  constructor: (elem_id) ->
    @el = $(elem_id)
    Pop.tables ||= []
    Pop.tables.push(this)

  redraw: () ->
    api = @el.dataTable().api()
    api.page.len(@page_length())
    api.draw(true)

  page_length: ->
    table_top = @el.offset().top
    win_height = $(window).height()
    row_height = 35
    head_foot_height = if $(window).width() > 768 then 100 else 120
    len = Math.floor((win_height-table_top-head_foot_height)/row_height)
    len = 15 if len < 10
    len

  render: (options = {}) ->
    table = this
    $.fn.DataTable.ext.pager.numbers_length = 5
    table = @el.DataTable
      sDom: "tip"
      bStateSave: false
      iDisplayLength: 8
      ajax:
        url: options.url
        type: 'POST'
        data: { authenticity_token: options.authenticity_token }
      processing: true
      serverSide: true
      pageLength: @page_length()
      columns: options.columns
      order: options.order
      language:
        url: options.i18n_url
      drawCallback: () ->
        $table = this
        api = $table.api()
        api.$('tr').click () ->
          url = api.row(this).data().url
          if $table.data("remote")?
            $.ajax
              url: url
              dataType: 'script'
          else
            window.location.href = url

      $(".pop-page-search").submit (e) ->
        e.preventDefault()
        table.search($(this).find("input.form-control").val()).draw()
        return false

$(window).on 'resize', () ->
  Pop.tables ||= []
  for table in Pop.tables
    table.redraw()
