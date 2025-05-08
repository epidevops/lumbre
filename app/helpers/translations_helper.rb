module TranslationsHelper
  def locale_collection
    I18n.available_locales.map do |locale|
      [ link_to(url_for(locale: locale), class: "flex flex-row items-center justify-center text-sm/6 gap-x-4 text-gray-700 hover:bg-gray-100") do
        concat tag.div(flag_for_locale(locale), class: "mr-3")
        concat "  "
        concat tag.div(t("locales." + locale.to_s), class: "text-sm/6")
      end, locale.to_s ]
    end
  end

  LOCALE_FLAGS = {
    "en": "🇺🇸",
    "es": "🇪🇸",
    "fr": "🇫🇷",
    "de": "🇩🇪",
    "pt-BR": "🇧🇷"
  }

  def flag_for_locale(locale)
    LOCALE_FLAGS[locale]
  end
end
