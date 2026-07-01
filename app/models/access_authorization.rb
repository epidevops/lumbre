class AccessAuthorization < ApplicationRecord
  STANDARD_ACTIONS = %w[
    index show new create edit update destroy destroy_all
    batch_actions index_download filter
  ].freeze

  ACTION_PREFIXES = %w[ba_ ma_ ca_ ai_].freeze

  # Backward-compatible alias used by policies and Active Admin integration.
  PUNDIT_ACTIONS = STANDARD_ACTIONS

  belongs_to :access_type
  belongs_to :access_resource, optional: true
  has_many :permission_grants, dependent: :destroy
  has_many :permissions, through: :permission_grants

  validates :key, presence: true, uniqueness: { scope: :access_type_id }
  validates :label, presence: true
  validate :validate_action
  validate :resource_required_for_resource_and_page_authorizations

  scope :navigation, -> { joins(:access_type).merge(AccessType.navigation) }
  scope :resources, -> { joins(:access_type).merge(AccessType.resources) }
  scope :pages, -> { joins(:access_type).merge(AccessType.pages) }
  scope :for_resource, ->(resource) {
    if resource.is_a?(AccessResource)
      where(access_resource: resource)
    else
      joins(:access_resource).where(access_resources: { resource_class: resource.to_s })
    end
  }
  scope :for_action, ->(action) { where(action: action.to_s) }
  scope :for_menu, ->(menu_key) { navigation.where(key: menu_key.to_s) }

  delegate :resource_class, to: :access_resource, allow_nil: true

  def self.allowed_action?(action)
    action = action.to_s
    return true if STANDARD_ACTIONS.include?(action)

    ACTION_PREFIXES.any? { |prefix| action.start_with?(prefix) && action.length > prefix.length }
  end

  def navigation?
    access_type&.key == AccessType::NAVIGATION
  end

  def resource_authorization?
    access_type&.key == AccessType::RESOURCES
  end

  def page_authorization?
    access_type&.key == AccessType::PAGES
  end

  private

    def validate_action
      return if action.blank?

      errors.add(:action, "is not allowed") unless self.class.allowed_action?(action)
    end

    def resource_required_for_resource_and_page_authorizations
      return if navigation?

      errors.add(:access_resource, "can't be blank") if access_resource.blank?
      errors.add(:action, "can't be blank") if action.blank?
    end
end
