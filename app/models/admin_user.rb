class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :two_factor_authenticatable, :two_factor_backupable, :database_authenticatable,
         :recoverable, :rememberable, :validatable,
         otp_backup_code_length: 6,
         otp_number_of_backup_codes: 10,
         otp_allowed_drift: 30

  include NoticedAssociations
  has_many :addresses, as: :addressable, dependent: :destroy
  has_many :phones, as: :phoneable, dependent: :destroy
  has_many :emails, as: :emailable, dependent: :destroy

  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :phones, allow_destroy: true
  accepts_nested_attributes_for :emails, allow_destroy: true

  serialize :otp_backup_codes, coder: JSON

  before_validation :password_required?

  include Avatar # , EmailValidations, NoticedAssociations
  rolify
  has_person_name

  scope :super_admin_users, -> { AdminUser.with_role(:super_admin).select(:id, :email) }

  def initials
    name.initials
  end

  def user_meta_data_tag
    {
      id:,         # Using Ruby 3.1+ shorthand syntax
      name:,
      initials:,
      avatar: {
        url: custom_public_avatar_url
      }
    }.to_json
  end

  def super_admin?
    has_role?(:super_admin)
  end

  private

    def password_required?
      # Don't require password for existing records unless password is being changed
      return false if persisted? && password.blank? && password_confirmation.blank?
      true
    end

    def custom_public_avatar_url
      return nil unless avatar.attached?

      Rails.application.routes.url_helpers.rails_blob_url(avatar_representation, only_path: true)
    end
end
