import backend from './crypto-backend'
import { str_to_bytes, b64decode, b64encode } from './encode'

stretch_password = (password, salt) ->
  crypto = await backend()
  password = str_to_bytes password
  crypto.stretch password, salt, 1 << 18

export encode_password = (password) ->
  crypto = await backend()
  salt = crypto.get_rand 16
  hash = await stretch_password password, salt

  salt: b64encode salt
  hash: b64encode hash

export sign_with_password = (password, salt, nonce) ->
  crypto = await backend()
  salt = b64decode salt
  nonce = b64decode nonce
  hash = await stretch_password password, salt
  key = await crypto.hmac_key hash
  b64encode await crypto.hmac key, nonce
