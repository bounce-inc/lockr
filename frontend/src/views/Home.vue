<template lang="pug">
.container
  ActiveBox.active-box
    .chooser-box
      .instruction {{ t('home_drop_or_choose') }}
      FileChooser(v-slot="{ open }" @file-chosen="file_chosen")
        Button(primary @click="open")
          FolderIcon
          | 
          | {{ t('home_btn_choose_file') }}
  Description
</template>

<script lang="coffee">
import ActiveBox from '../components/ActiveBox'
import Button from '../components/Button'
import Description from '../components/Description'
import FileChooser from '../components/FileChooser'
import FolderIcon from 'vue-material-design-icons/Folder'
import api from '../api'
import i18n, { t } from '../i18n'
import { show_error } from '../error'

export default
  components: {
    ActiveBox
    Button
    Description
    FileChooser
    FolderIcon
  }

  computed:
    lang: -> i18n.lang

  methods:
    t: t

    file_chosen: (file) ->
      @$router.push name: 'upload', params: f: file

    canon_path: ->
      path = "/#{i18n.lang}/"
      if @$route.path != path
        @$router.replace path

  mounted: ->
    @canon_path()
    try
      api 'GET', '/status'
    catch e
      show_error e

  watch:
    lang: -> @canon_path()
    $route: -> @canon_path()
</script>

<style scoped lang="stylus">
.active-box
  margin-bottom 1.6rem
.chooser-box
  width 100%
  display flex
  justify-content space-between
  align-items center
  .instruction
    flex-grow 1
</style>
