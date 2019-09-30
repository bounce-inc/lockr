<template lang="pug">
.file-list
  .less(v-if="show_all" @click="show_all = false")
    LessIcon
    | 
    | {{ t('filelist_less') }}
  FileInfo(
    v-for="file in files_to_show"
    :key="file.name"
    :file="file"
    :bold="false"
  )
  .more(v-if="more" @click="show_all = true")
    DotsIcon.dots
    MoreIcon
    | 
    | {{ t('filelist_more', { count: more }) }}
  .less(v-if="show_all" @click="show_all = false")
    LessIcon
    | 
    | {{ t('filelist_less') }}
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
</script>

<style scoped lang="stylus">
.file-list
  padding 1.2rem
  border-radius 1.2rem
  border 0.1rem solid #999
  margin 1.2rem 0
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
