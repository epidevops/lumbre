class Contact < ApplicationRecord
  include NoticedAssociations
  has_many :contact_messages, dependent: :destroy
  accepts_nested_attributes_for :contact_messages
end
