<template lang="pug">
.container
  svg.spinner(viewbox="0 0 32 32" width=32 height=32)
    circle(
      cx=16
      cy=16
      r=15
      strokewidth=1
      fill='none'
      stroke='#eee'
      stroke-dasharray='85 9'
    )
</template>

<style scoped lang="stylus">
.container
  text-align center
.spinner
  animation spin 1s linear infinite
@keyframes spin
  from
    transform rotate(0)
  to
    transform rotate(1turn)
  to
</style>
