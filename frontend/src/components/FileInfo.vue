<template lang="pug">
.fileinfo(
  v-if="file"
  v-touch:swipe.left="swipeLeft"
  v-touch:swipe.right="swipeRight"
)
  .filename(:class="{ bold: bold }")
    ZipIcon(v-if="zip")
    FileIcon(v-else)
    | 
    | {{ file.name }} 
  .item {{ size }}
  .icon(
    v-if="removable"
    @click="$emit('remove')"
    :class="{ expose: expose_remove }"
  )
    CancelIcon(title="Delete")
</template>

<script lang="coffee">
import CancelIcon from 'vue-material-design-icons/Close'
import FileIcon from 'vue-material-design-icons/File'
import ZipIcon from 'vue-material-design-icons/FolderZip'
import i18n from '../i18n'
import { human_readable_size } from '../ui-util'

export default
  components: { CancelIcon, FileIcon, ZipIcon }
  props:
    file:
      type: [File, Object]
      required: true
    removable:
      type: Boolean
      default: false
    bold:
      type: Boolean
      default: true
    zip:
      type: Boolean
      default: false
  data: ->
    t: i18n.t.bind i18n
    expose_remove: false
  computed:
    size: -> human_readable_size @file.size
  methods:
    swipeLeft: -> @expose_remove = true
    swipeRight: -> @expose_remove = false
</script>

<style scoped lang="stylus">
.fileinfo
  display flex
  align-items center
.filename
  flex-grow 1
  word-break break-all
  &.bold
    font-weight bold
    font-size 2.0rem
.item
  font-size 1.4rem
  opacity 0.7
  margin-left 0.4rem
.icon
  padding-left 0.4rem
  font-size 2rem
  line-height 1
  transform translateY(-0.125em)
  cursor pointer
  opacity 0
  width 0
  overflow hidden
  display inline-block
  transition .2s
  &.expose
    width 2.4rem
    opacity 0.7
    overflow visible

.has-mouse .fileinfo
  .icon
    width auto
    overflow visible
  &:hover .icon
    opacity 0.7
</style>
