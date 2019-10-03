import CryptoWorker from 'worker-loader?name=js/worker.[hash:8].js!./crypto-worker'
import { b64encode } from './encode'

backend_p = null

web_crypto =
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

worker_crypto = ->
  worker = new CryptoWorker

  seqno = 0
  resolvers = {}

  worker.onmessage = (e) ->
    { seq, result, error } = e.data
    if error
      resolvers[seq].reject new Error error
    else
      resolvers[seq].resolve result

  send = (cmd, param) ->
    seq = ++seqno
    worker.postMessage { seq, cmd, param }
    new Promise (resolve, reject) -> resolvers[seq] = { resolve, reject }

  get_rand: (len) -> send 'get_rand', len
  hmac_key: (key) -> key
  hmac: (key, data) -> send 'hmac', { key, data }
  stretch: (password, salt, count) -> send 'stretch', { password, salt, count }
  enc_key: (key) -> key
  encrypt: (key, iv, data) -> send 'encrypt', { key, iv, data }
  decrypt: (key, iv, data) -> send 'decrypt', { key, iv, data }
build_backend = ->
  await import('webcrypto-shim') unless self.crypto

  result = {}
  need_alt = false

  try
    if web_crypto.get_rand(32).length == 32
      result.get_rand = web_crypto.get_rand
  catch e
    need_alt = true

  try
    key = await web_crypto.hmac_key new Uint8Array [1]
    h = await web_crypto.hmac key, new Uint8Array [1]
    if b64encode(h) == 'AEKMNQv6FuIpBmOvOM-6D6A5AFfiqzgCNNYg59fjMss'
      result.hmac_key = web_crypto.hmac_key
      result.hmac = web_crypto.hmac
  catch e
    need_alt = true

  try
    s = await web_crypto.stretch new Uint8Array([1]), new Uint8Array([1]), 1
    if b64encode(s) == 'r-hb_mQ1KIkzOQIoLyWl6IqyPhty5NKVfezOn2BIF6A'
      result.stretch = web_crypto.stretch
  catch e
    need_alt = true

  try
    key = await web_crypto.enc_key new Uint8Array 32
    iv = new Uint8Array 16
    plain = new Uint8Array [ 1, 2, 3, 4, 5 ]
    encrypted = await web_crypto.encrypt key, iv, plain
    decryped =  await web_crypto.decrypt key, iv, encrypted
    if b64encode(decryped) == b64encode(plain)
      result.enc_key = web_crypto.enc_key
      result.encrypt = web_crypto.encrypt
      result.decrypt = web_crypto.decrypt
  catch e
    need_alt = true

  if need_alt
    alt_backend = worker_crypto()
    { alt_backend..., result... }
  else
    result

export default get_backend = ->
  unless backend_p
    backend_p = build_backend()
  backend_p

export backend_info = ->
  backend = await get_backend()
  get_rand: backend.get_rand == web_crypto.get_rand
  hmac: backend.hmac == web_crypto.hmac
  stretch: backend.stretch == web_crypto.stretch
  encrypt: backend.encrypt == web_crypto.encrypt
