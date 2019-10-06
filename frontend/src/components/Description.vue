<template lang="pug">
article.description(v-html="html")
</template>

<script lang="coffee">
import description_ja from '../assets/description.ja.md'
import description_en from '../assets/description.en.md'
import i18n from '../i18n'

export default
  computed:
    html: ->
      if i18n.lang == 'ja'
        description_ja
      else
        description_en
</script>

<style lang="stylus">
.description
  margin-top 3.2rem
  h2
    margin-top 2.0rem
    line-height 3.2rem
    padding 0.8rem 0
    font-size 2.4rem
    border-bottom 0.1rem solid #666
  p
    margin 1.2rem 0
    line-height 2.4rem
  blockquote p
    font-size 1.4rem
    line-height 2.0rem
    opacity 0.7
    margin-left 0.8rem
    &::before
      content '* '
[lang="ja"]
  .description
    p
      line-height 2.8rem
    blockquote p
      line-height 2.0rem
</style>
