class Product < ApplicationRecord
  belongs_to :productable, polymorphic: true
  acts_as_sequenced scope: [ :productable_id, :productable_type, :category ]

  scope :active, -> { where(active: true) }
  scope :category, ->(category) { where(category: category) }
end
