import Vue from 'vue'
import Router from 'vue-router'
import Home from './views/Home'
import Upload from './views/Upload'
import UploadedFile from './views/UploadedFile'
import Download from './views/Download'
import Document from './views/Document'
import Test from './views/Test'
import { show_error } from './error'

Vue.use Router

NotFound = render: ->
  show_error new Error('notfound'), => @$router.push '/'

export default new Router
  mode: 'history'
  base: process.env.BASE_URL
  routes: [
    path: '/(ja|en)?/'
    name: 'home'
    component: Home
  ,
    path: '/upload'
    name: 'upload'
    component: Upload
    props: true
  ,
    path: '/u/:id'
    name: 'uploaded_file'
    component: UploadedFile
    props: true
  ,
    path: '/(en|ja)?/d'
    name: 'download'
    component: Download
  ,
    path: '/test'
    component: Test
  ,
    path: '/privacy'
    component: Document
    props:
      document: 'privacy'
  ,
    path: '*'
    component: NotFound
  ]
