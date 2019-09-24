import uuid from 'uuid/v4'
import cookies from 'js-cookie'

is_production = process.env.NODE_ENV == 'production'

cid = cookies.get('_ga') or uuid()
cookies.set '_ga', cid, path: '/', expires: 2 * 365, secure: is_production

export default ->
  params =
    cid: cid
    dl: location.origin + location.pathname + location.search
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

  query = ("#{key}=#{encodeURIComponent val}" for key, val of params).join '&'
  
  (new Image).src = "https://www.google-analytics.com/collect?#{query}"
