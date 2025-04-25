class ContactMessage < ApplicationRecord
  belongs_to :contact
  has_many :notifications, as: :record, dependent: :destroy, class_name: "Noticed::Event"

  validates :contact, :message, presence: true
end
