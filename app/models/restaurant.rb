class Restaurant < ApplicationRecord
  has_many :socials, as: :socialable, dependent: :destroy
  has_many :addresses, as: :addressable, dependent: :destroy
  has_many :phones, as: :phoneable, dependent: :destroy
  has_many :emails, as: :emailable, dependent: :destroy
  has_many :events, as: :eventable, dependent: :destroy
  has_many :products, as: :productable, dependent: :destroy

  accepts_nested_attributes_for :socials, allow_destroy: true
  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :phones, allow_destroy: true
  accepts_nested_attributes_for :emails, allow_destroy: true
  accepts_nested_attributes_for :events, allow_destroy: true
  accepts_nested_attributes_for :products, allow_destroy: true

  scope :active, -> { where(active: true) }
  scope :primary, -> { where(primary: true) }
end
