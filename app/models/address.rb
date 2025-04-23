class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  scope :active, -> { where(active: true) }
  scope :label, ->(label) { where(label: label) }
end
