# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  # content title: proc { I18n.t("active_admin.dashboard") } do
  content class: "px-4 py-16 md:py-32" do
    div class: "text-center mb-12" do
      h1 t(:welcome_back, name: current_admin_user.name), class: "text-4xl md:text-5xl lg:text-6xl font-extrabold text-gray-900 dark:text-gray-100 mb-4 bg-gradient-to-r from-indigo-600 to-purple-600 bg-clip-text text-transparent"
      para t(:welcome_message), class: "text-xl md:text-2xl text-gray-600 dark:text-gray-400 font-medium max-w-3xl mx-auto leading-relaxed"
    end

    # Quick Navigation Section
    div class: "mb-16" do
      h2 "Quick Navigation", class: "text-2xl md:text-3xl font-bold text-gray-900 dark:text-gray-100 mb-6"

      nav_cards = [
        {
          title: "Manage Restaurant",
          description: "This is where you can configure internationalization, socials, addreses, events, and more.",
          link: "/admin/restaurants/1/edit",
          image: "lumbre_banner.jpeg"
        },
        {
          title: "Manage Products",
          description: "This is where you can configure products, categories, and more.",
          link: "/admin/products",
          image: "lumbre_banner.jpeg"
        },
        {
          title: "Manage Me",
          description: "View and edit your account, change your password, and more.",
          link: "/admin/admin_users/#{current_admin_user.id}/edit",
          image: "lumbre_banner.jpeg"
        }
      ]

      div class: "grid grid-cols-2 md:grid-cols-3 gap-8" do
        render partial: "card", collection: nav_cards
      end
    end

    # Possible Issues Section - Missing Translations
    # Get products with missing translations formatted for cards
    translation_cards = Product.missing_translations_for_cards.map do |card_data|
      # Get the record from the dynamic key (:product, :restaurant, etc.)
      record = card_data[:product] || card_data.values.find { |v| v.is_a?(Product) }
      card_data.merge(
        link: "/admin/products/#{card_data[:id]}/edit",
        product_id: card_data[:id]  # Add for backward compatibility with card partial
      )
    end

    # Display Possible Issues section only if there are translation issues
    if translation_cards.any?
      div class: "mb-16" do
        h2 "Possible Issues", class: "text-2xl md:text-3xl font-bold text-gray-900 dark:text-gray-100 mb-6"

        div class: "grid grid-cols-2 md:grid-cols-3 gap-8" do
          render partial: "card_missing_translation", collection: translation_cards, as: :card
        end
      end
    end

    # div class: "px-4 py-16 md:py-32 text-center m-auto max-w-3xl" do
    #   h2 "Welcome to ActiveAdmin", class: "text-base font-semibold leading-7 text-indigo-600 dark:text-indigo-500"
    #   para "This is the default page", class: "mt-2 text-3xl sm:text-4xl font-bold text-gray-900 dark:text-gray-200"
    #   para class: "mt-6 text-xl leading-8 text-gray-700 dark:text-gray-400" do
    #     text_node "To update the content, edit the"
    #     strong "app/admin/dashboard.rb"
    #     text_node "file to get started."
    #   end
    # end

    # div class: "px-4 pb-8 m-auto max-w-3xl" do
    #   para "Url Options", class: "mt-2 text-3xl sm:text-4xl font-bold text-gray-900 dark:text-gray-200 text-center"
    #   ul class: "mt-6 text-xl leading-8 text-gray-700 dark:text-gray-400 list-none p-0 text-left whitespace-nowrap" do
    #     li "ActiveStorage::Current.url_options: #{ActiveStorage::Current.url_options}"
    #     li "ActiveStorage::Current.url_options = { protocol: request.protocol, host: request.host, port: request.port }"
    #     li "protocol: #{request.protocol}, host: #{request.host}, port: #{request.port}"
    #     li "Rails.application.routes.default_url_options: #{Rails.application.routes.default_url_options}"
    #   end
    # end
  end
end
