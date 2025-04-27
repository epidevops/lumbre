class Contact < ApplicationRecord
  include Avatar, EmailValidations, NoticedAssociations
  has_person_name
  has_many :contact_messages, dependent: :destroy
end
