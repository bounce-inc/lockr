<template lang="pug">
article(v-html="html")
</template>

<script lang="coffee">
import i18n from '../i18n'
import privacy_en from '../assets/privacy.en.md'
import privacy_ja from '../assets/privacy.ja.md'

export default
  props:
    document:
      type: String
      required: true
  computed:
    html: ->
      switch @document
        when 'privacy'
          if i18n.lang == 'en' then privacy_en else privacy_ja
        else
          throw new Error 'Invalid document'
</script>

<style lang="stylus">
article
  h2, h3
    &:not(:first-child)
      margin-top 1em
  p
    margin 0.5em 0
  ul
    margin-left 2em
</style>
