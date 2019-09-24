<template lang="pug">
Button(@click="$emit('click')")
  CancelIcon
  | 
  | {{ t('app_cancel') }}
</template>

<script lang="coffee">
import Button from './Button'
import CancelIcon from 'vue-material-design-icons/CloseCircle'
import { t } from '../i18n'

export default
  components: { Button, CancelIcon }
  methods: { t }
</script>
