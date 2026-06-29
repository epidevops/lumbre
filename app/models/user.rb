class User < ApplicationRecord
  include Avatar, EmailValidations, NoticedAssociations
  has_person_name

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :visits, class_name: "Ahoy::Visit", as: :user, dependent: :nullify
  has_many :ahoy_events, class_name: "Ahoy::Event", as: :user, dependent: :nullify
end
