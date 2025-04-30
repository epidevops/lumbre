class AdminUser < ApplicationRecord
  rolify
  include Avatar, EmailValidations, NoticedAssociations
  has_person_name
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  # enum preferred_locale: %w[I18n.available_locales.map(&:to_s).join(" ")]

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

  private

    def custom_public_avatar_url
      return nil unless avatar.attached?

      Rails.application.routes.url_helpers.rails_blob_url(avatar_thumb, only_path: true)
    end
end
