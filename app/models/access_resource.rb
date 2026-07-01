class AccessResource < ApplicationRecord
  KINDS = %w[model page].freeze

  has_many :access_authorizations, dependent: :restrict_with_exception
  has_many :permission_resource_scopes, dependent: :restrict_with_exception
  has_many :permissions, through: :permission_resource_scopes

  validates :key, presence: true, uniqueness: true
  validates :resource_class, presence: true, uniqueness: true
  validates :label, presence: true
  validates :source, presence: true
  validates :kind, inclusion: { in: KINDS }

  scope :ordered, -> { order(:label) }
  scope :models, -> { where(kind: "model") }
  scope :pages, -> { where(kind: "page") }

  def self.page_resource_class(page)
    "ActiveAdmin::Page:#{page.resource_name.param_key}"
  end

  def page?
    kind == "page"
  end
end
