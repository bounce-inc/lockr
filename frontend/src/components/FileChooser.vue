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
      if items?.length
        return if items[0].kind != 'file'
      ev.preventDefault()
      ev.dataTransfer.dropEffect = 'copy'
      @items = items.length
      @dragging = true
      clearTimeout @dragTimer
    onDragLeave: ->
      clearTimeout @dragTimer
      @dragTimer = setTimeout (=> @dragging = false), 100
    onDrop: (ev) ->
      return unless @dragging
      @dragging = false
      return unless ev.dataTransfer.files.length
      ev.preventDefault()
      @fileChosen ev.dataTransfer.files
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
