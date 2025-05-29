class Store < ApplicationRecord
  has_many :addresses, as: :addressable, dependent: :destroy
  has_many :socials, as: :socialable, dependent: :destroy
  has_many :products, as: :productable, dependent: :destroy
  has_many :events, as: :eventable, dependent: :destroy

  accepts_nested_attributes_for :events, allow_destroy: true

  extend Mobility
  translates :name, type: :string
  translates :slogan, type: :string

  scope :active, -> { where(active: true) }
  scope :primary, -> { where(primary: true) }
end
