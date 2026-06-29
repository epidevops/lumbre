class Ahoy::Event < ApplicationRecord
  include Ahoy::QueryMethods

  self.table_name = "ahoy_events"

  belongs_to :visit
  belongs_to :user, polymorphic: true, optional: true

  scope :for_admin_users, -> { where(user_type: "AdminUser") }
  scope :for_site_users, -> { where(user_type: "User") }

  def admin_user
    user if user_type == "AdminUser"
  end

  def admin_user=(record)
    self.user = record
  end

  def site_user
    user if user_type == "User"
  end

  def site_user=(record)
    self.user = record
  end

  serialize :properties, coder: JSON
end
