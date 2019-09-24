<template lang="pug">
.container
  .input-wrapper
    input.input(type="file" @change="onInputChange" ref="input")
  slot(v-bind="{ open }")

  p.dropbox(v-if="dragging")
    DropIcon.icon
    |  
    | {{ t('file_chooser_drop_it') }}

  GlobalEvents(
    @dragover="onDragOver"
    @dragleave="onDragLeave"
    @drop="onDrop"
  )
</template>

<script lang="coffee">
import DropIcon from 'vue-material-design-icons/Water'
import GlobalEvents from 'vue-global-events'
import i18n from '../i18n'
import { is_file_readable } from '../util'
import { show_error } from '../error'

export default
  components: { DropIcon, GlobalEvents }
  data: ->
    t: i18n.t.bind i18n
    dragging: false
    dragTimer: 0
  methods:
    open: ->
      @$refs.input.click()
    onInputChange: (ev) ->
      return unless ev.target.files.length
      @fileChosen ev.target.files[0]
      ev.target.value = null
    onDragOver: (ev) ->
      items = ev.dataTransfer.items
      if items?.length
        return if items[0].kind != 'file'
      ev.preventDefault()
      ev.dataTransfer.dropEffect = 'copy'
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
      @fileChosen ev.dataTransfer.files[0]
    fileChosen: (file) ->
      unless await is_file_readable file
        return show_error new Error 'fileread'
      @$emit 'file-chosen', file
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
