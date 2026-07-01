class PermissionResourceScope < ApplicationRecord
  belongs_to :permission, inverse_of: :permission_resource_scopes
  belongs_to :access_resource, inverse_of: :permission_resource_scopes
  belongs_to :index_scope_rule, inverse_of: :permission_resource_scopes

  validates :access_resource_id, uniqueness: { scope: :permission_id }

  delegate :key, to: :index_scope_rule, prefix: true
  delegate :resource_class, :label, to: :access_resource
end
