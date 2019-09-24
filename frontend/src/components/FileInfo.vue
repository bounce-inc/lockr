<template lang="pug">
.container(v-if="file")
  .filename
    FileIcon
    | 
    | {{ file.name }}
  .item {{ t('fileinfo_size') }}: {{ size }}
  .item(v-if="mtime") {{ t('fileinfo_last_modified') }}: {{ mtime }}
</template>

<script lang="coffee">
import FileIcon from 'vue-material-design-icons/File'
import { human_readable_size, locale_date_time } from '../ui-util'
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
    mtime: ->
      @file.lastModified and locale_date_time new Date @file.lastModified
</script>

<style scoped lang="stylus">
.filename
  font-size 2.0rem
  font-weight bold
</style>
