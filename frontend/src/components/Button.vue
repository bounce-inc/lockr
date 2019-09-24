<template lang="pug">
button(
  :class="{ primary: primary }"
  :type="primary ? 'submit' : 'button'"
  @click="onclick"
)
  span
    slot
</template>

<script lang="coffee">
export default
  props:
    primary:
      type: Boolean
      default: false
    href:
      default: null
  methods:
    onclick: (ev) ->
      if @href
        @$router.push @href
      else
        @$emit 'click', ev
</script>

<style scoped lang="stylus">
button
  border 0.1rem solid #444
  border-radius 0.4rem
  padding 0.5rem 1.5rem
  &.primary
    background-color #444
    border-color #555
    color #fff
  &:disabled
    opacity .25
    pointer-events none
  &:focus
    border-color #666
  transition all .2s
  white-space nowrap
  outline none

.has-mouse
  button
    &:hover
      box-shadow 0.1rem 0.1rem 1rem rgba(0, 0, 0, .3)
      color #fff
      &:not(.primary)
        background-color #444
      &.primary
        background-color #555
    &:active
      box-shadow none
    span
      position relative // for IE
</style>
