<template lang="pug">
.file-list
  .less(v-if="show_all" @click="show_all = false")
    LessIcon
    | 
    | {{ t('filelist_less') }}
  FileInfo.file-info(
    v-for="file in files_to_show"
    :key="file.name"
    :file="file"
    :bold="false"
    :removable="removable"
    @remove="remove(file)"
  )
  .more(v-if="more" @click="show_all = true")
    DotsIcon.dots
    MoreIcon
    | 
    | {{ t('filelist_more', { count: more }) }}
</template>

<script lang="coffee">
import FileInfo from './FileInfo'
import MoreIcon from 'vue-material-design-icons/ChevronDown'
import LessIcon from 'vue-material-design-icons/ChevronUp'
import DotsIcon from 'vue-material-design-icons/DotsVertical'
import { t } from '../i18n'

N = 5

export default
  components: { FileInfo, MoreIcon, LessIcon, DotsIcon }
  props:
    files:
      type: Array
      required: true
    removable:
      type: Boolean
      default: false
  data: ->
    show_all: false
  computed:
    files_to_show: ->
      if @show_all
        @files
      else
        @files[0...N]
    more: ->
      if @show_all
        0
      else
        Math.max 0, @files.length - N
  methods:
    t: t
    remove: (file) ->
      i = @files.indexOf file
      @files.splice i, 1
</script>

<style scoped lang="stylus">
.file-list
  padding 1.2rem
  border-radius 1.2rem
  border 0.1rem solid #999
  margin 1.2rem 0
.file-info:not(:last-child)
  margin-bottom 0.8rem
.more, .less
  font-size 1.4rem
  opacity 0.7
  text-align center
  cursor pointer
  .dots
    font-size 1.6rem
    opacity 1
    float left
</style>
