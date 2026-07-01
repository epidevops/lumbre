class Permission < ApplicationRecord
  belongs_to :role

  has_many :permission_grants, dependent: :destroy, inverse_of: :permission
  has_many :access_authorizations, through: :permission_grants
  has_many :permission_resource_scopes, dependent: :destroy, inverse_of: :permission
  has_many :access_resources, through: :permission_resource_scopes
  has_many :index_scope_rules, through: :permission_resource_scopes

  accepts_nested_attributes_for :permission_grants,
    allow_destroy: true,
    reject_if: :reject_permission_grant?
  accepts_nested_attributes_for :permission_resource_scopes,
    allow_destroy: true,
    reject_if: :reject_blank_resource_scope?

  validates :role_id, uniqueness: true

  before_validation :dedupe_resource_scopes

  def assign_default_grants!
    AccessType.includes(access_authorizations: :access_resource).order(:name).find_each do |access_type|
      access_type.access_authorizations.each do |authorization|
        next if permission_grants.any? { |grant| grant.access_authorization_id == authorization.id }

        permission_grants.build(access_authorization: authorization, granted: false)
      end
    end
  end

  def grant_for(access_authorization)
    permission_grants.find { |grant| grant.access_authorization_id == access_authorization.id } ||
      permission_grants.build(access_authorization: access_authorization, granted: false)
  end

  def granted?(access_authorization)
    permission_grants.granted.exists?(access_authorization:)
  end

  def granted_access_types
    AccessType
      .joins(:access_authorizations)
      .where(access_authorizations: { id: permission_grants.granted.select(:access_authorization_id) })
      .distinct
      .order(:name)
  end

  def resource_scope_for(access_resource)
    permission_resource_scopes.find { |resource_scope| resource_scope.access_resource_id == access_resource.id }
  end

  def resource_scope_for_form(access_resource)
    resource_scope_for(access_resource) ||
      permission_resource_scopes.build(
        access_resource: access_resource,
        index_scope_rule: IndexScopeRule.find_by(key: "all") || IndexScopeRule.default
      )
  end

  private

    def reject_permission_grant?(attributes)
      attributes["id"].blank? && !ActiveModel::Type::Boolean.new.cast(attributes["granted"])
    end

    def reject_blank_resource_scope?(attributes)
      attributes["access_resource_id"].blank?
    end

    def dedupe_resource_scopes
      permission_resource_scopes
        .group_by(&:access_resource_id)
        .each_value do |scopes|
          next if scopes.one?

          keeper = scopes.find(&:persisted?) || scopes.last
          scopes.each do |resource_scope|
            resource_scope.mark_for_destruction if resource_scope != keeper
          end
        end

      permission_resource_scopes.each do |resource_scope|
        resource_scope.mark_for_destruction if resource_scope.access_resource_id.blank?
      end
    end
end
