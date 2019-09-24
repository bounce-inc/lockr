import { HmacSha256 } from 'asmcrypto.js/dist_es5/hmac/hmac-sha256'
import { Pbkdf2HmacSha256 } from 'asmcrypto.js/dist_es5/pbkdf2/pbkdf2-hmac-sha256'
import { AES_CBC } from 'asmcrypto.js/dist_es5/aes/cbc'
import { str_to_bytes } from './encode'

export default
  get_rand: (len) ->
    # XXX not crypto safe
    x = str_to_bytes Date.now().toString()
    y = str_to_bytes Math.random().toString()
    @hmac x, y

  hmac_key: (key) -> key

  hmac: (key, data) -> new HmacSha256(key).process(data).finish().result

  stretch: (password, salt, count) -> Pbkdf2HmacSha256 password, salt, count, 32

  enc_key: (key) -> key

  encrypt: (key, iv, data) -> AES_CBC.encrypt data, key, true, iv

  decrypt: (key, iv, data) -> AES_CBC.decrypt data, key, true, iv
