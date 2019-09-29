<template lang="pug">
.fileinfo(v-if="file")
  .info
    span.item {{ size }}
  .filename
    FileIcon
    | {{ file.name }} 
</template>

<script lang="coffee">
import FileIcon from 'vue-material-design-icons/File'
import { human_readable_size } from '../ui-util'
import i18n from '../i18n'

export default
  components: { FileIcon }
  props:
    file:
      type: [File, Object]
      required: true
  data: ->
    t: i18n.t.bind i18n
  computed:
    size: -> human_readable_size @file.size
</script>

<style scoped lang="stylus">
.filename
  font-size 2.0rem
  line-height 3.0rem
  font-weight bold
.info
  font-size 1.4rem
  line-height 3.0rem
  opacity 0.7
  margin-left 0.8rem
  float right
.fileinfo::after
  content ''
  display block
  clear both
</style>
