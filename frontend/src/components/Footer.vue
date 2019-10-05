<template lang="pug">
footer
  .share {{ i18n.t('app_share') }} 
    a(
      :href="`https://twitter.com/share?url=${share_url}`"
      target="_blank"
      rel="noopener"
    )
      TwitterIcon.icon(title="Twitter")
    | 
    a(
      :href="`https://www.facebook.com/sharer/sharer.php?u=${share_url}`"
      target="_blank"
      rel="noopener"
    )
      FacebookIcon.icon(title="Facebook")
    a(
      v-if="i18n.lang == 'ja'"
      href="http://b.hatena.ne.jp/entry/s/lockr.jp/ja/"
      target="_blank"
      rel="noopener"
    )
      HatenaBookmarkIcon.icon(title="はてなブックマーク")

  .github
    a(
      href="https://github.com/bounce-inc/lockr"
      target="_blank"
      rel="noopener"
    )
      GitHubIcon.icon(title="Source code")

  .privacy
    router-link(to="/privacy") {{ i18n.t('app_privacy_policy') }}

  .terms
    router-link(to="/terms") {{ i18n.t('app_terms_of_use') }}

  .lang
    a(
      href="/ja/"
      v-if="i18n.lang === 'en'"
      @click.prevent="i18n.set_lang('ja')"
    ) 日本語
    a(
      href="/en/"
      v-if="i18n.lang === 'ja'"
      @click.prevent="i18n.set_lang('en')"
    ) English

  .copyright
    span.copy &copy; 
    | {{ year }} 
    a(href="https://www.bounce-inc.jp/" target="_blank" rel="noopener")
      | {{ i18n.t('app_copyright') }}
</template>

<script lang="coffee">
import FacebookIcon from 'vue-material-design-icons/FacebookBox'
import GitHubIcon from 'vue-material-design-icons/GithubCircle'
import HatenaBookmarkIcon from './HatenaBookmarkIcon'
import TwitterIcon from 'vue-material-design-icons/Twitter'
import i18n from '../i18n'

export default
  components: {
    FacebookIcon
    GitHubIcon
    HatenaBookmarkIcon
    TwitterIcon
  }
  data: -> { i18n }
  computed:
    year: -> new Date().getFullYear()
    share_url: -> encodeURIComponent "https://lockr.jp/#{@i18n.lang}/"
</script>

<style lang="stylus">
footer
  opacity 0.7
  font-size 1.4rem
  margin 3.2rem 0 0.8rem
  display flex
  justify-content space-between
  align-items center
  .icon
    font-size 2rem
    margin-right 0.4rem
  .copyright .copy
    font-family Helvetica, Arial, san-serif
  a
    text-decoration none
  .lang
    cursor pointer
    white-space nowrap

@media (max-width: 640px)
  footer
    flex-direction column
    & > *
      margin-bottom .8rem
</style>
