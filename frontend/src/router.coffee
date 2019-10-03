import Vue from 'vue'
import Router from 'vue-router'
import { show_error } from './error'

Document = -> import('./views/Document')
Download = -> import('./views/Download')
Home = -> import('./views/Home')
Login = -> import('./views/Login')
Test = -> import('./views/Test')
Upload = -> import('./views/Upload')
UploadedFile = -> import('./views/UploadedFile')

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
    path: '/terms'
    component: Document
    props:
      document: 'terms'
  ,
    path: '/login'
    component: Login
  ,
    path: '*'
    component: NotFound
  ]
