import WebCrypto from './web-crypto'
import WorkerCrypto from './worker-crypto'
import base32Encode from 'base32-encode'
import {
  b64encode
  b64decode
  str_to_bytes
  bytes_to_str
  join_bytes
} from './encode'

build_backend = (alt='worker') ->
  await import('webcrypto-shim') unless self.crypto

  result = {}
  need_alt = false

  try
    if WebCrypto.get_rand(32).length == 32
      result.get_rand = WebCrypto.get_rand
  catch e
    need_alt = true

  try
    key = await WebCrypto.hmac_key new Uint8Array [1]
    h = await WebCrypto.hmac key, new Uint8Array [1]
    if b64encode(h) == 'AEKMNQv6FuIpBmOvOM-6D6A5AFfiqzgCNNYg59fjMss'
      result.hmac_key = WebCrypto.hmac_key
      result.hmac = WebCrypto.hmac
  catch e
    need_alt = true

  try
    s = await WebCrypto.stretch new Uint8Array([1]), new Uint8Array([1]), 1
    if b64encode(s) == 'r-hb_mQ1KIkzOQIoLyWl6IqyPhty5NKVfezOn2BIF6A'
      result.stretch = WebCrypto.stretch
  catch e
    need_alt = true

  try
    key = await WebCrypto.enc_key new Uint8Array 32
    iv = new Uint8Array 16
    plain = new Uint8Array [ 1, 2, 3, 4, 5 ]
    encrypted = await WebCrypto.encrypt key, iv, plain
    decryped =  await WebCrypto.decrypt key, iv, encrypted
    if b64encode(decryped) == b64encode(plain)
      result.enc_key = WebCrypto.enc_key
      result.encrypt = WebCrypto.encrypt
      result.decrypt = WebCrypto.decrypt
  catch e
    need_alt = true

  if need_alt
    if alt != 'worker'
      throw new Error 'worker only for now'
    alt_backend = WorkerCrypto()
    { alt_backend..., result... }
  else
    result

export default class Crypto
  init: (b64secret) ->
    @backend = await build_backend()
    if b64secret
      @secret = b64decode b64secret
    else
      key = await @backend.hmac_key @backend.get_rand 32
      data = str_to_bytes 'Secret'
      @secret = await @backend.hmac key, data

  get_upload_id: ->
    secret_key = await @backend.hmac_key @secret
    data = str_to_bytes 'Upload ID'
    k = await @backend.hmac secret_key, data
    id = k.slice 0, 10
    base32Encode id, 'RFC4648'

  set_salt: (b64salt) ->
    @salt = b64decode b64salt
    @iv = @salt
    @metadata_iv = @iv

  get_b64secret: -> b64encode @secret

  get_metadata_key: -> @derive_crypt_key 'Metadata Key'

  get_content_key: -> @_content_key or= @derive_crypt_key 'Content Key'

  get_sign_key: -> await @derive_raw_key 'Signing Key'

  derive_crypt_key: (info) -> @backend.enc_key await @derive_raw_key info

  derive_raw_key: (info) ->
    prk = await @get_prk()
    data = str_to_bytes info
    new Uint8Array await @backend.hmac prk, data

  get_prk: ->
    @_prk_p or= do =>
      salt_key = await @backend.hmac_key @salt
      prk = await @backend.hmac salt_key, @secret
      @backend.hmac_key prk

  block_iv: (block_num) ->
    iv = @iv.slice 0
    dv = new DataView iv.buffer
    val = dv.getUint32 12
    mixed = val ^ (block_num + 1)
    dv.setUint32 12, mixed
    iv

  set_password: (password) -> @raw_auth_key_p = @stretch password, 1<<18

  stretch: (password, count) ->
    pw = str_to_bytes password
    @backend.stretch pw, @secret, count

  get_raw_auth_key: -> @raw_auth_key_p or= @derive_raw_key 'Authentication'

  get_auth_key: -> @backend.hmac_key await @get_raw_auth_key()

  get_b64_auth_key: -> b64encode await @get_raw_auth_key()

  encrypt_metadata: (object) ->
    data = str_to_bytes JSON.stringify object
    key = await @get_metadata_key()
    b64encode await @backend.encrypt key, @metadata_iv, data

  decrypt_metadata: (b64data) ->
    key = await @get_metadata_key()
    data = b64decode b64data
    bytes = await @backend.decrypt key, @metadata_iv, data
    JSON.parse bytes_to_str bytes

  encrypt_block: (block_num, data) ->
    key = await @get_content_key()
    iv = @block_iv block_num
    @backend.encrypt key, iv, data

  decrypt_block: (block_num, data) ->
    key = await @get_content_key()
    iv = @block_iv block_num
    @backend.decrypt key, iv, data

  sign_nonce: (b64nonce) ->
    key = await @get_auth_key()
    data = b64decode b64nonce
    b64encode await @backend.hmac key, data

  backend_info: ->
    get_rand: @backend.get_rand == WebCrypto.get_rand
    hmac: @backend.hmac == WebCrypto.hmac
    stretch: @backend.stretch == WebCrypto.stretch
    encrypt: @backend.encrypt == WebCrypto.encrypt
