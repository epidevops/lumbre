class Phone < ApplicationRecord
  belongs_to :phoneable, polymorphic: true
  scope :active, -> { where(active: true) }
end
