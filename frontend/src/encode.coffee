import 'fast-text-encoding'

export str_to_bytes = do ->
  encoder = new TextEncoder()
  (str) -> encoder.encode str

export bytes_to_str = do ->
  decoder = new TextDecoder()
  (str) -> decoder.decode str

export b64encode = (bytes) ->
  b64 = btoa String.fromCharCode bytes...
  mapping =
    '+': '-'
    '/': '_'
    '=': ''
  b64.replace /[+/=]/g, (c) -> mapping[c]

export b64decode = (str) ->
  mapping =
    '-': '+'
    '_': '/'
  str = str.replace /[-_]/g, (c) -> mapping[c]
  n_pad = (4 - str.length % 4) % 4
  pad = '==='.slice 0, n_pad
  bin_str = atob str + pad
  Uint8Array.from bin_str, (c) -> c.charCodeAt 0

export join_bytes = (array) ->
  len = 0
  for bytes in array
    throw new Error 'Invalid array' unless bytes instanceof Uint8Array
    len += bytes.length
  output = new Uint8Array len
  offset = 0
  for bytes in array
    output.set bytes, offset
    offset += bytes.length
  output

export hex_encode = (bytes) ->
  Array.prototype.map.call bytes, (byte) -> ('0' + byte.toString 16).slice(-2)
    .join ''
