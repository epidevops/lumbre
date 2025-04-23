class Product < ApplicationRecord
  belongs_to :productable, polymorphic: true
  acts_as_sequenced scope: :productable

  scope :active, -> { where(active: true) }
  scope :category, ->(category) { where(category: category) }
end
