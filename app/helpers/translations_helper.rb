module TranslationsHelper
  def locale_collection
    I18n.available_locales.map do |locale|
      [ link_to(url_for(locale: locale), class: "group inline-flex gap-x-4 px-2.5 py-4 text-sm/6 text-gray-700 hover:bg-gray-100") do
        concat tag.div(flag_for_locale(locale), class: "flex items-center justify-start text-base")
        concat tag.div(t("locales." + locale.to_s), class: "flex items-center text-sm/6")
      end, locale.to_s ]
    end
  end

  LOCALE_FLAGS = {
    "en": "🇺🇸",
    "fr": "🇫🇷",
    "de": "🇩🇪",
    "pt-BR": "🇧🇷",
    "es-MX": "🇲🇽"
  }

  def flag_for_locale(locale)
    LOCALE_FLAGS[locale]
  end
end
