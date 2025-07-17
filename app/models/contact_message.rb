class ContactMessage < ApplicationRecord
  belongs_to :contact

  validates :contact, :message, presence: true, length: { maximum: 5000 }
  normalizes :message, with: ->(message) { ActionController::Base.helpers.sanitize(message) }
end
