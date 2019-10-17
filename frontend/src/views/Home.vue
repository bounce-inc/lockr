<template lang="pug">
.container
  ActiveBox.active-box
    .chooser-box
      .instruction(v-html="t(instruction)")
      .btn-bar
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
import i18n, { t } from '../i18n'
import { show_error } from '../error'
import { is_mobile } from '../util'

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
    instruction: -> if is_mobile then 'home_choose' else 'home_drop_or_choose'

  methods:
    t: t

    file_chosen: (files) ->
      @$router.push name: 'upload', params: f: files

    canon_path: ->
      path = "/#{i18n.lang}/"
      if @$route.path != path
        @$router.replace path

  mounted: ->
    @canon_path()

  watch:
    lang: -> @canon_path()
    $route: -> @canon_path()
</script>

<style scoped lang="stylus">
.active-box
  margin-bottom 1.6rem
.chooser-box
  .instruction
    flex-grow 1
    font-size 1.8rem
.btn-bar
  margin-top 0.8rem
  text-align right

@media (max-width 640px)
  .chooser-box
    display flex
    flex-direction column
    align-items center
</style>
