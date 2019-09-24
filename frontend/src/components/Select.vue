<template lang="pug">
.wrapper
  select.select(@change="$emit('input', $event.target.value)" :value="value")
    option(v-for="option in options" :key="option.value" :value="option.value")
      | {{ option.label }}
  DownIcon.icon
</template>

<script lang="coffee">
import DownIcon from 'vue-material-design-icons/ChevronDown'

export default
  props:
    options:
      type: Array
      required: true
    value:
      required: true
  components: { DownIcon }
</script>

<style scoped lang="stylus">
.wrapper
  display inline-block
  position relative
  .select
    padding 0.4rem 2.0rem 0.4rem 0.8rem
    border 0.1rem solid #666
    border-radius 0.4rem
    background #333
    color #eee
    option
      background inherit
      color inherit
  .icon
    position absolute
    right 0.4rem
    top 0.8rem
    pointer-events none
</style>
