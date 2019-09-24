export is_file_readable = (file) ->
  new Promise (resolve) ->
    reader = new FileReader
    reader.onload = -> resolve true
    reader.onerror = -> resolve false
    reader.readAsArrayBuffer file.slice 0, 1

export sleep = (msec) -> new Promise (resolve) -> setTimeout resolve, msec

ua = navigator.userAgent
is_safari = /Safari/.test(ua) and not /Chrome/.test(ua)
is_edge = /Edge/.test(ua)

export has_service_worker = navigator.serviceWorker and
  not (is_safari or is_edge)
