window.Pop ||= {}

Pop.init = ->
  @init_forms()
  @init_page()
  @init_show_flash()

  $("body").delegate ".modal", "shown.bs.modal", () ->
    Pop.init_forms()
    Pop.init_modal($(this))

  $("body").delegate ".modal", "hidden.bs.modal", () ->
    $(this).remove()

Pop.init_show_flash = () ->
  if gon?
    for idx, msg of gon.flash
      Pop.notify[msg[0]](msg[1])
    gon.flash = []

Pop.init_modal = ($el) ->
  $('[data-action="submit-modal-form"').each (i, el) ->
    $(this).on 'click', (ev) ->
      ev.preventDefault()
      $(this).closest(".modal-content").find(".modal-body form").submit()
      return false

  Pop.pages ||= []
  for page in Pop.pages
    if $(".modal#{page.selectors}").length > 0
      page.listener()

Pop.add_page = (selectors, listener) ->
  Pop.pages ||= []
  Pop.pages.push({ selectors: selectors, listener: listener})

Pop.init_page = () ->
  Pop.pages ||= []
  for page in Pop.pages
    if $(".page-body#{page.selectors}").length > 0
      page.listener()

Pop.refresh_html_content = (selector) ->
  url = $(selector).data("url")
  if url?
    $.ajax
      url: url,
      success: (data, status, xhr) ->
        $(selector).html(data)
      dataType: 'html'

$(document).on "turbolinks:load", ->
  Pop.init()
