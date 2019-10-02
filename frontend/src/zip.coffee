import Queue from './queue'
import crc32 from 'crc/crc32'
import { str_to_bytes } from './encode'

class ByteArray
  constructor: ->
    @capacity = 64
    @length = 0
    @buffer = new Uint8Array @capacity

  u8: (val) ->
    if @length >= @capacity
      orig_buffer = @buffer
      @capacity *= 2
      @buffer = new Uint8Array @capacity
      @buffer.set orig_buffer
    @buffer[@length++] = val & 0xff

  u16: (val) ->
    @u8 val
    @u8 val >> 8

  u32: (val) ->
    @u16 val
    @u16 val >> 16

  result: -> @buffer.slice 0, @length

dos_date = (date) ->
  y = date.getFullYear() - 1980
  m = date.getMonth() + 1
  d = date.getDate()
  (y << 9) | (m << 5) | d

dos_time = (date) ->
  h = date.getHours()
  m = date.getMinutes()
  s = date.getSeconds()
  (h << 11) | (m << 5) | (s >> 1)

class Entry
  constructor: (@file) ->
    timestamp =
      if @file.lastModified
        new Date @file.lastModified
      else
        new Date
    @date = dos_date timestamp
    @time = dos_time timestamp
    @name = str_to_bytes @file.name
    @crc = null
    if @file.size >= 4 * 1024 * 1024 * 1024
      throw new Error 'zip_file_too_large'
    if @name.length >= 1 << 16
      throw new Error 'zip_file_name_too_long'

  generate: (queue) ->
    await queue.write @local_header()
    await queue.write @name
    offset = 0
    loop
      data = await @read_file offset, 65536
      if data.length == 0
        break
      @crc = crc32 data, @crc
      await queue.write data
      offset += data.length
    if offset != @file.size
      throw new Error 'zip_file_change'
    await queue.write @descriptor()

  read_file: (offset, size) ->
    new Promise (resolve, reject) =>
      r = new FileReader
      r.onload = -> resolve new Uint8Array r.result
      r.onerror = (e) -> reject e
      r.readAsArrayBuffer @file.slice offset, offset + size

  local_header: ->
    header = new ByteArray
    header.u32 0x04034B50 # signature
    header.u16 20 # version
    header.u16 (1 << 3) | (1 << 11) # use descriptor, use UTF-8
    header.u16 0 # compression
    header.u16 @time
    header.u16 @date
    header.u32 0 # crc, use descriptor
    header.u32 0 # compressed size, use descriptor
    header.u32 0 # uncompressed size, use descriptor
    header.u16 @name.length
    header.u16 0 # length of extension field
    header.result()

  descriptor: ->
    desc = new ByteArray
    desc.u32 0x08074b50 # signature
    desc.u32 @crc
    desc.u32 @file.size
    desc.u32 @file.size
    desc.result()

  directory_entry: (offset) ->
    entry = new ByteArray
    entry.u32 0x02014b50 # signature
    entry.u16 20 # version
    entry.u16 20 # required version
    entry.u16 (1 << 3) | (1 << 11) # use descriptor, use UTF-8
    entry.u16 0 # compression
    entry.u16 @time
    entry.u16 @date
    entry.u32 @crc
    entry.u32 @file.size
    entry.u32 @file.size
    entry.u16 @name.length
    entry.u16 0 # length of extension field
    entry.u16 0 # comment length
    entry.u16 0 # disk number
    entry.u16 0 # internal attributes
    entry.u32 0 # external attributes
    entry.u32 offset
    entry.u8 b for b in @name
    entry.result()

  length: -> 30 + @name.length + @file.size + 16

export default class Zip
  constructor: (files) ->
    @files = (new Entry(file) for file in files)
    @queue = new Queue

  length: ->
    len = 22 # eocd
    for file in @files
      len += file.length() + 46 + file.name.length
    len

  eocd: (size, offset) ->
    eocd = new ByteArray
    eocd.u32 0x06054b50
    eocd.u16 0 # disk number
    eocd.u16 0 # disk number
    eocd.u16 @files.length
    eocd.u16 @files.length
    eocd.u32 size
    eocd.u32 offset
    eocd.u16 0 # comment length
    eocd.result()

  central_directory: ->
    offset = 0
    size = 0
    for file in @files
      entry = file.directory_entry offset
      offset += file.length()
      await @queue.write entry
      size += entry.length
    await @queue.write @eocd size, offset

  generate: ->
    do =>
      try
        for file in @files
          await file.generate @queue
        await @central_directory()
        await @queue.write new Uint8Array 0
      catch e
        console.error e
        @queue.error e
    @queue
