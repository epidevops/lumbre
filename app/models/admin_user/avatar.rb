module AdminUser::Avatar
  extend ActiveSupport::Concern

  THUMBNAIL_WEBP_VARIANT = { resize_to_fill: [ 512, 512 ], format: :webp }

  included do
    has_one_attached :avatar do |attachable|
      attachable.variant :thumb, THUMBNAIL_WEBP_VARIANT
    end
  end


  class_methods do
    def from_avatar_token(sid)
      find_signed!(sid, purpose: :avatar)
    end
  end

  def has_avatar?
    avatar.attached?
  end

  def avatar_thumb_processed
    avatar.variant(:thumb).processed
  end

  def avatar_representation
    avatar.representation(:thumb).processed
  end

  # def avatar_thumb_url
  #   return nil unless avatar.attached?

  #   Rails.application.routes.url_helpers.rails_blob_url(avatar_thumb, only_path: true)
  # end

  # def avatar_url
  #   Rails.application.routes.url_helpers.url_for avatar if avatar.attached?
  # end

  def avatar_token
    signed_id(purpose: :avatar)
  end
end
