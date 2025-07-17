class ContactMessage < ApplicationRecord
  belongs_to :contact

  validates :contact, :message, presence: true
end
