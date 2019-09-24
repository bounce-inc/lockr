export default
  get_rand: (len) ->
    bytes = new Uint8Array len
    crypto.getRandomValues bytes
    bytes

  hmac_key: (key) ->
    p = crypto.subtle.importKey 'raw',
      key
      name: 'HMAC'
      hash:
        name: 'SHA-256'
      false
      ['sign', 'verify']

  hmac: (key, data) ->
    new Uint8Array await crypto.subtle.sign name: 'HMAC', key, data

  enc_key: (key) ->
    crypto.subtle.importKey 'raw',
      key
      name: 'AES-CBC'
      false
      ['encrypt', 'decrypt']

  encrypt: (key, iv, data) ->
    p = crypto.subtle.encrypt name: 'AES-CBC', iv: iv, key, data
    new Uint8Array await p

  decrypt: (key, iv, data) ->
    p = crypto.subtle.decrypt name: 'AES-CBC', iv: iv, key, data
    new Uint8Array await p

  stretch: (password, salt, count) ->
    key = await crypto.subtle.importKey 'raw',
      password
      name: 'PBKDF2'
      false
      ['deriveBits']
    new Uint8Array await crypto.subtle.deriveBits
      name: 'PBKDF2'
      hash: 'SHA-256'
      salt: salt
      iterations: count
      key
      256
