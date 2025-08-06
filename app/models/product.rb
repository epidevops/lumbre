class Product < ApplicationRecord
  include Photos

  belongs_to :productable, polymorphic: true

  positioned on: [ :productable, :category ]

  scope :active, -> { where(active: true) }
  scope :category, ->(category) { where(category: category) }
  extend Mobility
  translates :title, type: :string
  translates :description, type: :text
  translates :recommended_text, type: :string
end
