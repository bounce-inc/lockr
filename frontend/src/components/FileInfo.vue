<template lang="pug">
.fileinfo(
  v-if="file"
  v-touch:swipe.left="swipeLeft"
  v-touch:swipe.right="swipeRight"
)
  .info
    span.item {{ size }}
    span.icon(
      v-if="removable"
      @click="$emit('remove')"
      :class="{ expose: expose_remove }"
    )
      CancelIcon(title="Delete")
  .filename(:class="{ bold: bold }")
    FileIcon
    | {{ file.name }} 
</template>

<script lang="coffee">
import CancelIcon from 'vue-material-design-icons/CloseCircle'
import FileIcon from 'vue-material-design-icons/File'
import i18n from '../i18n'
import { human_readable_size } from '../ui-util'

export default
  components: { CancelIcon, FileIcon }
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
.filename.bold
  font-weight bold
  font-size 2.0rem
  line-height 3.0rem
.info
  float right
  .item
    font-size 1.4rem
    line-height 3.0rem
    opacity 0.7
    margin-left 0.4rem
  .icon
    padding-left 0.4rem
    font-size 2rem
    line-height 3rem
    cursor pointer
    opacity 0
    width 0
    overflow hidden
    display inline-block
    transition .2s
    vertical-align -0.9rem
    &.expose
      width 2.4rem
      opacity 1

.has-mouse .fileinfo
  .icon
    width auto
  &:hover .icon
    opacity 1
    
.fileinfo::after
  content ''
  display block
  clear both
</style>
