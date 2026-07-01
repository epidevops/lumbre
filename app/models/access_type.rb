class AccessType < ApplicationRecord
  NAVIGATION = "navigation"
  RESOURCES = "resources"
  PAGES = "pages"

  KEYS = [ NAVIGATION, RESOURCES, PAGES ].freeze

  has_many :access_authorizations, dependent: :destroy

  validates :key, presence: true, uniqueness: true, inclusion: { in: KEYS }
  validates :name, presence: true

  scope :navigation, -> { where(key: NAVIGATION) }
  scope :resources, -> { where(key: RESOURCES) }
  scope :pages, -> { where(key: PAGES) }
end
