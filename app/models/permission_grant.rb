class PermissionGrant < ApplicationRecord
  belongs_to :permission, inverse_of: :permission_grants
  belongs_to :access_authorization

  validates :access_authorization_id, uniqueness: { scope: :permission_id }

  scope :granted, -> { where(granted: true) }
end
