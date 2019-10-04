<template lang="pug">
.container
  .input-wrapper
    input.input(type="file" multiple @change="onInputChange" ref="input")
  slot(v-bind="{ open }")

  p.dropbox(v-if="dragging")
    DropIcon.icon
    |  
    | {{ drop_message }}

  GlobalEvents(
    @dragover="onDragOver"
    @dragleave="onDragLeave"
    @drop="onDrop"
  )
</template>

<script lang="coffee">
import DropIcon from 'vue-material-design-icons/Water'
import GlobalEvents from 'vue-global-events'
import { t }  from '../i18n'
import { is_file_readable } from '../util'
import { show_error } from '../error'

scan_entries = (items) ->
  return null unless items?.length
  item = items[0]
  getAsEntry =
    if typeof item.getAsEntry == 'function'
      'getAsEntry'
    else if typeof item.webkitGetAsEntry == 'function'
      'webkitGetAsEntry'
    else
      null
  return null unless getAsEntry

  files = []

  scan_entry = (entry, path) ->
    if entry.isDirectory
      new_path = [path..., entry.name]
      reader = entry.createReader()
      await new Promise (resolve, reject) ->
        reader.readEntries ((entries) ->
          for e in entries
            await scan_entry e, new_path
          resolve()
        ), ((e) -> reject e)
    else if entry.isFile
      await new Promise (resolve, reject) ->
        entry.file ((file) ->
          pathname = [path..., file.name].join '/'
          Object.defineProperty file, 'name', get: -> pathname
          files.push file
          resolve()
        ), ((e) -> reject e)

  # We can't access items after await, so start scanning them at once and
  # later sort them.
  await Promise.all(
    for item in items
      scan_entry item[getAsEntry](), []
  )

  files.sort (a, b) ->
    if a.name < b.name then -1 else if a.name > b.name then 1 else 0

  files

export default
  components: { DropIcon, GlobalEvents }
  data: ->
    t: t
    dragging: false
    dragTimer: 0
    items: 0
  methods:
    open: ->
      @$refs.input.click()
    onInputChange: (ev) ->
      return unless ev.target.files.length
      files = [ev.target.files...]
      @fileChosen files
      ev.target.value = null
    onDragOver: (ev) ->
      items = ev.dataTransfer.items
      if items
        if items.length == 0 or items[0].kind != 'file'
          return
      ev.preventDefault()
      ev.dataTransfer.dropEffect = 'copy'
      @items = items?.length
      @dragging = true
      clearTimeout @dragTimer
    onDragLeave: ->
      clearTimeout @dragTimer
      @dragTimer = setTimeout (=> @dragging = false), 100
    onDrop: (ev) ->
      return unless @dragging
      @dragging = false
      ev.preventDefault()
      files = ev.dataTransfer.files # Save files before await
      files = (await scan_entries ev.dataTransfer.items) or files
      return unless files?.length
      @fileChosen files
    fileChosen: (files) ->
      for file in files
        unless await is_file_readable file
          return show_error new Error 'fileread'
      @$emit 'file-chosen', [files...]
  computed:
    drop_message: ->
      if @items > 1
        t('file_chooser_drop_them')
      else
        t('file_chooser_drop_it')
</script>

<style scoped lang="stylus">
.input-wrapper
  height 0 
  width 0
  overflow hidden
.dropbox
  position fixed
  width 100%
  height 100%
  left 0
  top 0
  z-index 1
  background rgba(0, 0, 0, .8)
  display flex
  justify-content center
  align-items center
  font-size 2.4rem
  .icon
    transform translateY(-0.125em)
</style>
