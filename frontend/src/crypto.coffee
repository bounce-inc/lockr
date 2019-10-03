import backend from './crypto-backend'
import base32Encode from 'base32-encode'
import {
  b64encode
  b64decode
  str_to_bytes
  bytes_to_str
} from './encode'

export default class Crypto
  init: (b64secret) ->
    @backend = await backend()
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
