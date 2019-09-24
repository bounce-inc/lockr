export default (title, body) ->
  return unless window.Notification
  return unless Notification.permission == 'granted'
  new Notification title, body: body, icon: '/favicon.ico'
  .addEventListener 'click', (e) ->
    window.focus()
    e.target.close()
