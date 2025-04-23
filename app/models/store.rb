class Store < ApplicationRecord
  has_many :addresses, as: :addressable, dependent: :destroy
  has_many :socials, as: :socialable, dependent: :destroy
  has_many :products, as: :productable, dependent: :destroy
end
