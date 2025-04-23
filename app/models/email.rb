class Email < ApplicationRecord
  belongs_to :emailable, polymorphic: true
  scope :active, -> { where(active: true) }
end
