import Vue from 'vue'
import 'ress'
import 'vue-material-design-icons/styles.css'
import service_worker from 'service-worker-loader!./sw'
import { has_service_worker } from './util'
import App from './App'
import router from './router'
import ga from './ga'

service_worker() if has_service_worker

router.afterEach -> Vue.nextTick ga

new Vue
  router: router
  render: (h) => h App
.$mount '#app'
