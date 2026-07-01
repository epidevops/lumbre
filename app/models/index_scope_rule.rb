class IndexScopeRule < ApplicationRecord
  PRIORITY = %w[all role_peers current_admin_user author].freeze
  DEFAULT_KEY = "current_admin_user"

  has_many :permission_resource_scopes, dependent: :restrict_with_exception
  has_many :permissions, through: :permission_resource_scopes

  validates :key, presence: true, uniqueness: true
  validates :name, presence: true

  scope :ordered, -> { order(:name) }

  def self.default
    find_by!(key: DEFAULT_KEY)
  end

  def self.all_rule
    find_by!(key: "all")
  end
end
