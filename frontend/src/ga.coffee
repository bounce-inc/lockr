import uuid from 'uuid/v4'
import cookies from 'js-cookie'

is_production = process.env.NODE_ENV == 'production'

cid = cookies.get('_ga') or uuid()
cookies.set '_ga', cid, path: '/', expires: 2 * 365, secure: is_production

send = (params={}) ->
  defaults =
    cid: cid
    dl: location.origin + location.pathname
    dr: document.referrer
    dt: document.title
    je: 0
    sr: "#{screen.width}x#{screen.height}"
    t: 'pageview'
    tid: 'UA-148448799-1'
    ul: navigator.language
    v: 1
    vp: "#{innerWidth}x#{innerHeight}"
    z: Math.round(Math.random() * 1e12)

  params = { defaults..., params... }

  query = ("#{key}=#{encodeURIComponent val}" for key, val of params).join '&'
  
  (new Image).src = "https://www.google-analytics.com/collect?#{query}"

export pageview = send

export event = (category, action, value) ->
  send t: 'event', ec: category, ea: action, ev: value
