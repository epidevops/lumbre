class Product < ApplicationRecord
  belongs_to :productable, polymorphic: true
  positioned on: [ :productable, :category ]

  include Photos
  include TranslationValidation

  scope :active, -> { where(active: true) }
  scope :category, ->(category) { where(category: category) }

  extend Mobility
  translates :title, type: :string
  translates :description, type: :text
  translates :recommended_text, type: :string

  # Specify which attributes require translation validation
  def self.required_translated_attributes
    [ :title, :description ]
  end

  # Optional: Override to customize which attribute is used for display
  # Defaults to first required_translated_attribute (:title in this case)
  # def self.translation_display_attribute
  #   :title
  # end
end
