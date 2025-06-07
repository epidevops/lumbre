module AdminUser::Avatar
  extend ActiveSupport::Concern

  SQUARE_WEBP_VARIANT = { resize_to_limit: [ 512, 512 ], format: :webp }

  included do
    has_one_attached :avatar do |attachable|
      attachable.variant :thumb, resize_to_limit: [ 100, 100 ]
    end
  end


  class_methods do
    def from_avatar_token(sid)
      find_signed!(sid, purpose: :avatar)
    end
  end

  def avatar_thumb
    avatar.variant(:thumb).processed
  end

  def avatar_thumb_url
    return nil unless avatar.attached?

    Rails.application.routes.url_helpers.rails_blob_url(avatar_thumb, only_path: true)
  end

  def avatar_url
    Rails.application.routes.url_helpers.url_for avatar if avatar.attached?
  end

  def avatar_token
    signed_id(purpose: :avatar)
  end
end
