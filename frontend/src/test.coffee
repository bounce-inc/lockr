import Crypto from './crypto'
import {
  b64encode
  b64decode
  join_bytes
  str_to_bytes
  bytes_to_str
  hex_encode
} from './encode'

assert_eq = (a, b) ->
  if a != b
    throw new Error "#{a} is not equal to #{b}"

assert_not_eq = (a, b) ->
  if a == b
    throw new Error "#{a} is equal to #{b}"

export default ->
  bytes = b64decode b64encode(new Uint8Array [128, 129, 130])
  assert_eq bytes.length, 3
  assert_eq bytes[0], 128

  bytes = join_bytes [new Uint8Array([1]), new Uint8Array([2])]
  assert_eq bytes.length, 2
  assert_eq bytes[0], 1
  assert_eq bytes[1], 2

  c = new Crypto
  await c.init()
  assert_eq c.secret.length, 32

  c = new Crypto
  await c.init 'SHyAJyKw-QXg2C4q4XHizeOHDOS_XXpfgIDvqg7VfrQ'

  upload_id = await c.get_upload_id()
  assert_eq upload_id, 'GG7GDQGZCSAQG5MI'

  c.set_salt 'G68c1zG0gy1Ku-ukdC0x9g'

  await c.set_password 'test123'

  emeta = await c.encrypt_metadata { name: 'テスト.txt', size: 1 }
  dmeta = await c.decrypt_metadata emeta
  assert_eq dmeta.name, 'テスト.txt'

  block0 = await c.encrypt_block 0, str_to_bytes 'foobar'
  block1 = await c.encrypt_block 1, str_to_bytes 'foobar'
  assert_not_eq block0, block1
  assert_eq b64encode(block0), '86WExknNBn0QQ-3p0CbeEA'

  d_block0 = bytes_to_str await c.decrypt_block 0, block0
  d_block1 = bytes_to_str await c.decrypt_block 1, block1
  assert_eq d_block0, 'foobar'
  assert_eq d_block1, 'foobar'

  enc = await c.encrypt_block 1, new Uint8Array(1<<22 - 16)
  dec = await c.decrypt_block 1, enc

  b64nonce = 'arGR2CUf9jy76SkgqSpQOq5DbjoWiwkbgZXgMJMz1OQ'
  assert_eq await c.sign_nonce(b64nonce),
    'PE50YZKpL-Z_qSd1sLYlZdaEn-33OAHGfwlsXwh6bwU'

  true
