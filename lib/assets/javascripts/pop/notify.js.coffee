Pop.notify = {}

Pop.notify.opts =
  closeButton: true,
  debug: false,
  positionClass: "toast-bottom-right",
  onclick: null,
  showDuration: "300",
  hideDuration: "1000",
  timeOut: "5000",
  extendedTimeOut: "1000",
  showEasing: "swing",
  hideEasing: "linear",
  showMethod: "fadeIn",
  hideMethod: "fadeOut"


Pop.notify.info = (msg) ->
  toastr.info(msg, null, Pop.notify.opts)

Pop.notify.success = (msg) ->
  toastr.success(msg, null, Pop.notify.opts)

Pop.notify.notice = (msg) ->
  Pop.notify.success(msg)

Pop.notify.error = (msg) ->
  toastr.error(msg, null, Pop.notify.opts)

Pop.notify.alert = (msg) ->
  Pop.notify.error(msg)

Pop.notify.warning = (msg) ->
  toastr.warning(msg, null, Pop.notify.opts)
