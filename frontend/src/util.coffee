export is_file_readable = (file) ->
  new Promise (resolve) ->
    reader = new FileReader
    reader.onload = -> resolve true
    reader.onerror = -> resolve false
    reader.readAsArrayBuffer file.slice 0, 1

export sleep = (msec) -> new Promise (resolve) -> setTimeout resolve, msec

export has_service_worker = do ->
  ua = navigator.userAgent
  m = /Chrome\/(\d+)/.exec(ua)
  chrome = if m then m[1] | 0 else 0
  m = /Firefox\/(\d+)/.exec(ua)
  firefox = if m then m[1] | 0 else 0
  navigator.serviceWorker and (chrome >= 76 or firefox >= 68)
