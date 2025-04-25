class Contact < ApplicationRecord
  include Avatar, EmailValidations, NameOfPerson, NoticedAssociations
  has_many :contact_messages, dependent: :destroy
end
