class Ahoy::Visit < ApplicationRecord
  self.table_name = "ahoy_visits"

  has_many :events, class_name: "Ahoy::Event"
  belongs_to :user, polymorphic: true, optional: true

  scope :admin_site, -> { where("landing_page LIKE ?", "%/admin%") }
  scope :public_site, -> { where("landing_page NOT LIKE ? OR landing_page IS NULL", "%/admin%") }
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
end
