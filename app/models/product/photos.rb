module Product::Photos
  extend ActiveSupport::Concern

  THUMBNAIL_MAX_WIDTH = 1200
  THUMBNAIL_MAX_HEIGHT = 800
  THUMBNAIL_WEBP_VARIANT = { resize_to_fill: [ THUMBNAIL_MAX_WIDTH, THUMBNAIL_MAX_HEIGHT, { crop: :centre } ], format: :webp, saver: { subsample_mode: "on", strip: true, interlace: true, lossless: true, quality: 100 }, preprocessed: true }
  SQUARE_WEBP_VARIANT = { resize_to_fill: [ 512, 512 ], format: :webp, saver: { subsample_mode: "on", strip: true, interlace: true, lossless: true, quality: 80 }, preprocessed: true }


  included do
    has_many_attached :photos do |attachable|
      attachable.variant :thumb, THUMBNAIL_WEBP_VARIANT
      attachable.variant :square, SQUARE_WEBP_VARIANT
    end
  end

  # module ClassMethods
  #   def create_with_photos!(attributes)
  #     create!(attributes).tap(&:process_photos)
  #   end
  # end

  # def attached_photos?
  #   photos.attached?
  # end

  # def s3_file_key
  #   "#{Rails.env}/products/photos/#{file_name.dasherize}.webp"
  # end


  # def render_photo
  #   square_variant = photos.variant(:square)

  #   send_webp_blob_file square_variant.key
  # end

  # def process_photos
  #   ensure_photos_analyzed
  #   process_photos_thumbnail
  # end


  # private
  #   def ensure_photos_analyzed
  #     photos&.analyze
  #   end

  #   def process_photos_thumbnail
  #     case
  #     when photo.video?
  #       photo.preview(format: :webp).processed
  #     when photo.representable?
  #       photo.representation(:thumb).processed
  #       photo.representation(:square).processed
  #     end
  #   end

  #   def send_webp_blob_file(key)
  #     send_file ActiveStorage::Blob.service.path_for(key), content_type: "image/webp", disposition: :inline
  #   end
end
