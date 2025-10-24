# TranslationValidation Concern
#
# Provides translation and photo attachment validation for models using Mobility.
# This concern is fully generic and can be included in any model with translated attributes.
#
# Photo validation is automatic via duck typing:
# - If model includes Photos concern (which provides has_photos? method), photos are validated
# - If model doesn't include Photos concern, photo validation is skipped
# - No configuration needed - convention over configuration!
#
# Usage Example:
#
#   class Product < ApplicationRecord
#     include Photos  # Provides has_photos? method - automatically enables photo validation
#     include TranslationValidation
#
#     translates :title, :description
#
#     def self.required_translated_attributes
#       [ :title, :description ]
#     end
#
#     # Optional: customize display attribute (defaults to first required attribute)
#     def self.translation_display_attribute
#       :title
#     end
#   end
#
#   class Restaurant < ApplicationRecord
#     include TranslationValidation  # No Photos concern = no photo validation
#     translates :name, :slogan, :about_text
#
#     def self.required_translated_attributes
#       [ :name, :about_text ]
#     end
#
#     def self.translation_display_attribute
#       :name  # Use 'name' instead of first required attribute
#     end
#   end
#
# Then use:
#   # Efficient database queries using Mobility's i18n scope
#   Product.with_missing_translations                    # Only translation issues
#   Product.with_validation_issues                       # Translations + photos (if Photos concern included)
#   Product.active.with_validation_issues                # Chainable with other scopes
#   Product.missing_translation_ids_for(locale: :es, attribute: :title)
#   Product.missing_photos_ids                           # IDs without photos (empty array if no Photos concern)
#
#   # Dashboard formatting - returns array of hashes with dynamic keys
#   Product.validation_issues_for_cards  # or .missing_translations_for_cards (alias)
#   #=> [{
#   #     product: #<Product:0x...>,         # Key is dynamic based on model
#   #     title: "Product Name",
#   #     id: 1,
#   #     missing_locales: [:fr, :de],
#   #     has_photos: false,
#   #     model_name: "Product"
#   #   }]
#
#   Restaurant.validation_issues_for_cards
#   #=> [{
#   #     restaurant: #<Restaurant:0x...>,   # Key changes based on model
#   #     title: "Restaurant Name",
#   #     id: 1,
#   #     missing_locales: [:es_MX],
#   #     has_photos: true,
#   #     model_name: "Restaurant"
#   #   }]
#
#   # Instance methods
#   product.missing_translation_locales      # [:fr, :de, ...]
#   product.has_missing_translations?        # true/false
#   product.has_photos?                      # true/false (from Photos concern)
#   product.has_validation_issues?           # true/false (checks both translations and photos)
#
module TranslationValidation
  extend ActiveSupport::Concern

  included do
    # Returns array of locales where required translations are missing
    # Subclasses should override `required_translated_attributes` to specify which attributes to check
    def missing_translation_locales
      I18n.available_locales.select do |locale|
        missing_any_translation_for_locale?(locale)
      end
    end

    # Check if product has any missing translations
    def has_missing_translations?
      missing_translation_locales.any?
    end

    # Check if record has any validation issues (translations or photos)
    # Note: relies on has_photos? method from Photos concern if present
    def has_validation_issues?
      missing_translations = has_missing_translations?
      # If model has has_photos? method (from Photos concern), check if photos are missing
      missing_photos = respond_to?(:has_photos?) && !has_photos?

      missing_translations || missing_photos
    end

    # Returns a display name for this record based on configured attribute
    # Used for dashboard cards and other display purposes
    def translation_display_name
      # Use the configured display attribute from the model
      display_attr = self.class.translation_display_attribute

      if display_attr && respond_to?(display_attr)
        # Get the value of the configured attribute (e.g., title, name)
        value = public_send(display_attr)
        value.presence || "#{self.class.model_name.human} ##{id}"
      else
        # Fallback if no attribute configured
        "#{self.class.model_name.human} ##{id}"
      end
    end
  end

  class_methods do
    # Returns IDs of records missing translations for a specific locale and attribute
    # Uses Mobility's i18n query interface for efficient database queries
    def missing_translation_ids_for(locale:, attribute:)
      # Get all record IDs
      all_ids = pluck(:id)

      # Get IDs that have translations for this locale/attribute using Mobility's query
      with_translation_ids = Mobility.with_locale(locale) do
        i18n.where.not(attribute => nil).where.not(attribute => "").pluck(:id)
      end

      # Return IDs that are missing (difference between all and those with translations)
      all_ids - with_translation_ids
    end

    # Returns IDs of records missing photos (if model has photos association)
    # Uses duck typing - if model has photos_attachments association, check for missing photos
    def missing_photos_ids
      # Check if model has photos association (from Photos concern)
      return [] unless reflect_on_association(:photos_attachments)

      # Find records without photo attachments
      left_joins(:photos_attachments)
        .where(active_storage_attachments: { id: nil })
        .distinct
        .pluck(:id)
    end

    # Returns records that have missing translations for any required attribute/locale
    # This is more efficient as it uses database queries instead of loading all records
    def with_missing_translations
      missing_ids = Set.new

      I18n.available_locales.each do |locale|
        required_translated_attributes.each do |attribute|
          missing_ids.merge(missing_translation_ids_for(locale: locale, attribute: attribute))
        end
      end

      where(id: missing_ids.to_a)
    end

    # Returns records with validation issues (missing translations or photos)
    def with_validation_issues
      missing_ids = Set.new

      # Add IDs with missing translations
      I18n.available_locales.each do |locale|
        required_translated_attributes.each do |attribute|
          missing_ids.merge(missing_translation_ids_for(locale: locale, attribute: attribute))
        end
      end

      # Add IDs with missing photos
      missing_ids.merge(missing_photos_ids)

      where(id: missing_ids.to_a)
    end

    # Format records for dashboard cards
    # Returns array of hashes with record data and missing locales/photos
    # Fully generic - works with any model that includes this concern
    def validation_issues_for_cards
      records = with_validation_issues

      # Use dynamic key based on model name (e.g., :product, :restaurant)
      record_key = model_name.param_key.to_sym  # "Product" -> :product, "Restaurant" -> :restaurant

      records.map do |record|
        {
          record_key => record,                               # Dynamic: :product, :restaurant, etc.
          title: record.translation_display_name,
          id: record.id,                                      # Generic :id
          missing_locales: record.missing_translation_locales,
          has_photos: record.respond_to?(:has_photos?) ? record.has_photos? : true,  # Use existing method if available
          model_name: model_name.human                        # "Product", "Restaurant"
        }
      end
    end

    # Alias for backward compatibility
    def missing_translations_for_cards
      validation_issues_for_cards
    end

    # Override this in models to specify which attributes require translation
    # Example: [ :title, :description ]
    def required_translated_attributes
      []
    end

    # Override this to specify which attribute to use as the display name
    # Defaults to the first required translated attribute
    # Example: :title or :name
    def translation_display_attribute
      required_translated_attributes.first
    end
  end

  private

  def missing_any_translation_for_locale?(locale)
    # Convert locale to underscore format (e.g., 'es-MX' -> 'es_mx')
    locale_normalized = locale.to_s.downcase.tr("-", "_")

    # Check each required attribute
    self.class.required_translated_attributes.any? do |attribute|
      # Use Mobility's automatic locale accessor methods
      # These return nil when translation doesn't exist (no fallback)
      value = public_send("#{attribute}_#{locale_normalized}")
      value.nil?
    end
  end
end
