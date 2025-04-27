class Product < ApplicationRecord
  belongs_to :productable, polymorphic: true
  positioned on: [ :productable, :category ]

  scope :active, -> { where(active: true) }
  scope :category, ->(category) { where(category: category) }
end
