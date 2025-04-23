class Social < ApplicationRecord
  belongs_to :socialable, polymorphic: true
  scope :active, -> { where(active: true) }
end
