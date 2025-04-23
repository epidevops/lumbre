class Event < ApplicationRecord
  belongs_to :eventable, polymorphic: true
  scope :active, -> { where(active: true) }
end
