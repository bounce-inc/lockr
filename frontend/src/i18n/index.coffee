import en from './en'
import ja from './ja'

KEY = 'lockr_lang'

translations = { en, ja }

export default i18n =
  lang: 'en'

  t: (key, args={}) ->
    text = translations[@lang][key] or translations.en[key]
    return null unless text
    for key, val of args
      re = new RegExp '\\#\\{' + key + '(\\|(.+?)\\|(.+?))?\\}', 'g'
      text = text.replace re, (_, noun, singular, plural) ->
        if noun
          if val > 1
            "#{val} #{plural}"
          else
            "#{val} #{singular}"
        else
          val
    text

  set_lang: (lang) ->
    localStorage[KEY] = @lang = lang
    document.title = "Lockr: #{@t 'app_catch'}"
    document.documentElement.lang = lang

lang_from_url = ->
  match = /^\/(en|ja)\/$/.exec location.pathname
  if match
    match[1]
  else
    null

lang = lang_from_url() or localStorage[KEY] or navigator.language.split('-')[0]
unless translations[lang]
  lang = 'en'
i18n.set_lang lang

export t = i18n.t.bind i18n
