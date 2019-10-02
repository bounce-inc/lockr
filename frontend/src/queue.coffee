import { join_bytes } from './encode'

export default class Queue
  constructor: (@max=10) ->
    @queue = []
    @reader = null
    @writer = null
    @err = null

  read: ->
    if @queue.length == 0
      if @reader
        throw new Error 'Queue is empty and waiting'
      await new Promise (resolve) => @reader = resolve
      @reader = null
    throw @err if @err
    @writer() if @writer
    data = @queue.shift()
    data

  write: (data) ->
    if @queue.length >= @max
      if @writer
        throw new Error 'Queue is full and waiting'
      await new Promise (resolve) => @writer = resolve
      @writer = null
    throw @err if @err
    @queue.push data
    @reader() if @reader

  error: (e) ->
    @err = e
    @reader() if @reader
    @writer() if @writer

export file_reader = (file, block_size) ->
  queue = new Queue
  do ->
    offset = 0
    try
      loop
        block = await new Promise (resolve, reject) =>
          blob = file.slice offset, offset + block_size
          reader = new FileReader
          reader.onload = -> resolve new Uint8Array reader.result
          reader.onerror = -> reject reader.error
          reader.readAsArrayBuffer blob
        await queue.write block
        if block.length == 0
          break
        offset += block_size
    catch e
      console.error e
      queue.error e
  queue

export block_aligner = (inqueue, block_size) ->
  outqueue = new Queue
  do ->
    try
      buffer = new Uint8Array 0
      loop
        while buffer.length < block_size
          chunk = await inqueue.read()
          if chunk.length == 0
            await outqueue.write buffer
            await outqueue.write chunk
            return
          buffer = join_bytes [buffer, chunk]
        await outqueue.write buffer.slice 0, block_size
        buffer = buffer.slice block_size
    catch e
      console.error e
      outqueue.error e
  outqueue
